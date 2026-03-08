#!/usr/bin/env python3
"""
English Quiz Generator
将英语听力材料转换为交互式Quiz网页
"""

import json
import os
import http.server
import socketserver
import random
from datetime import datetime

PORT = 8080

def generate_quiz_html(title, questions):
    """生成Quiz网页HTML"""
    
    questions_json = json.dumps(questions, ensure_ascii=False)
    
    html = f'''<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>📚 English Quiz - {title}</title>
    <style>
        * {{
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }}
        
        body {{
            font-family: 'Comic Sans MS', 'Chalkboard SE', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }}
        
        .container {{
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            max-width: 600px;
            width: 100%;
            padding: 30px;
            text-align: center;
        }}
        
        h1 {{
            color: #667eea;
            margin-bottom: 20px;
            font-size: 2em;
        }}
        
        .progress {{
            background: #eee;
            border-radius: 10px;
            height: 20px;
            margin-bottom: 20px;
            overflow: hidden;
        }}
        
        .progress-bar {{
            background: linear-gradient(90deg, #667eea, #764ba2);
            height: 100%;
            transition: width 0.3s ease;
            border-radius: 10px;
        }}
        
        .question {{
            font-size: 1.3em;
            color: #333;
            margin-bottom: 25px;
            line-height: 1.6;
        }}
        
        .options {{
            display: flex;
            flex-direction: column;
            gap: 12px;
        }}
        
        .option {{
            background: #f8f9fa;
            border: 3px solid #e9ecef;
            border-radius: 12px;
            padding: 15px 20px;
            font-size: 1.1em;
            cursor: pointer;
            transition: all 0.3s ease;
        }}
        
        .option:hover {{
            background: #667eea;
            color: white;
            border-color: #667eea;
            transform: translateY(-2px);
        }}
        
        .option.correct {{
            background: #28a745;
            color: white;
            border-color: #28a745;
        }}
        
        .option.wrong {{
            background: #dc3545;
            color: white;
            border-color: #dc3545;
        }}
        
        .feedback {{
            margin-top: 20px;
            padding: 15px;
            border-radius: 10px;
            font-size: 1.1em;
        }}
        
        .feedback.correct {{
            background: #d4edda;
            color: #155724;
        }}
        
        .feedback.wrong {{
            background: #f8d7da;
            color: #721c24;
        }}
        
        .next-btn {{
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 15px 40px;
            font-size: 1.2em;
            border-radius: 25px;
            cursor: pointer;
            margin-top: 20px;
            transition: transform 0.3s ease;
        }}
        
        .next-btn:hover {{
            transform: scale(1.05);
        }}
        
        .result {{
            display: none;
        }}
        
        .result.show {{
            display: block;
        }}
        
        .score {{
            font-size: 4em;
            color: #667eea;
            margin: 20px 0;
        }}
        
        .stars {{
            font-size: 3em;
            margin: 10px 0;
        }}
        
        .stats {{
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin: 20px 0;
            text-align: left;
        }}
        
        .stat-item {{
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #e9ecef;
        }}
        
        .stat-item:last-child {{
            border-bottom: none;
        }}
        
        .restart-btn {{
            background: #28a745;
            color: white;
            border: none;
            padding: 15px 40px;
            font-size: 1.2em;
            border-radius: 25px;
            cursor: pointer;
            margin-top: 20px;
        }}
        
        .explanation {{
            font-size: 0.9em;
            color: #666;
            margin-top: 10px;
            font-style: italic;
        }}
    </style>
</head>
<body>
    <div class="container">
        <div id="quiz">
            <h1>📚 {title}</h1>
            <div class="progress">
                <div class="progress-bar" id="progressBar"></div>
            </div>
            <div class="question" id="question"></div>
            <div class="options" id="options"></div>
            <div class="feedback" id="feedback" style="display:none;"></div>
            <button class="next-btn" id="nextBtn" style="display:none;" onclick="nextQuestion()">Next ➡️</button>
        </div>
        
        <div class="result" id="result">
            <h1>🎉 Great Job! 🎉</h1>
            <div class="stars" id="stars"></div>
            <div class="score"><span id="score">0</span>/<span id="total">0</span></div>
            <div class="stats" id="stats"></div>
            <button class="restart-btn" onclick="restart()">🔄 Try Again</button>
        </div>
    </div>
    
    <script>
        const questions = {questions_json};
        let currentQuestion = 0;
        let score = 0;
        let answers = [];
        
        function showQuestion() {{
            const q = questions[currentQuestion];
            document.getElementById('question').textContent = q.question;
            document.getElementById('progressBar').style.width = ((currentQuestion + 1) / questions.length * 100) + '%';
            
            const optionsDiv = document.getElementById('options');
            optionsDiv.innerHTML = '';
            
            q.options.forEach((opt, i) => {{
                const btn = document.createElement('div');
                btn.className = 'option';
                btn.textContent = opt;
                btn.onclick = () => selectOption(i);
                optionsDiv.appendChild(btn);
            }});
            
            document.getElementById('feedback').style.display = 'none';
            document.getElementById('nextBtn').style.display = 'none';
        }}
        
        function selectOption(index) {{
            const q = questions[currentQuestion];
            const options = document.querySelectorAll('.option');
            const feedback = document.getElementById('feedback');
            
            answers.push({{
                question: q.question,
                selected: index,
                correct: q.correct,
                correctAnswer: q.options[q.correct]
            }});
            
            if (index === q.correct) {{
                options[index].classList.add('correct');
                feedback.className = 'feedback correct';
                feedback.innerHTML = '✅ Correct! ' + (q.explanation || '');
                score++;
            }} else {{
                options[index].classList.add('wrong');
                options[q.correct].classList.add('correct');
                feedback.className = 'feedback wrong';
                feedback.innerHTML = '❌ The correct answer is: ' + q.options[q.correct];
            }}
            
            feedback.style.display = 'block';
            document.getElementById('nextBtn').style.display = 'inline-block';
            
            // Disable all options
            options.forEach(opt => opt.style.pointerEvents = 'none');
        }}
        
        function nextQuestion() {{
            currentQuestion++;
            if (currentQuestion < questions.length) {{
                showQuestion();
            }} else {{
                showResult();
            }}
        }}
        
        function showResult() {{
            document.getElementById('quiz').style.display = 'none';
            document.getElementById('result').classList.add('show');
            document.getElementById('score').textContent = score;
            document.getElementById('total').textContent = questions.length;
            
            // Stars
            const percentage = score / questions.length;
            let stars = '⭐';
            if (percentage >= 0.8) stars = '⭐⭐⭐⭐⭐';
            else if (percentage >= 0.6) stars = '⭐⭐⭐⭐';
            else if (percentage >= 0.4) stars = '⭐⭐⭐';
            else if (percentage >= 0.2) stars = '⭐⭐';
            document.getElementById('stars').textContent = stars;
            
            // Stats
            let statsHtml = '';
            answers.forEach((a, i) => {{
                const status = a.selected === a.correct ? '✅' : '❌';
                statsHtml += f'<div class="stat-item"><span>Q{{i+1}}</span><span>{{status}}</span></div>';
            }});
            document.getElementById('stats').innerHTML = statsHtml;
        }}
        
        function restart() {{
            currentQuestion = 0;
            score = 0;
            answers = [];
            document.getElementById('quiz').style.display = 'block';
            document.getElementById('result').classList.remove('show');
            showQuestion();
        }}
        
        // Start
        showQuestion();
    </script>
</body>
</html>'''
    
    return html

def save_and_serve(title, questions, output_dir='~/Downloads'):
    """保存HTML并启动服务"""
    
    # 生成文件名
    safe_title = ''.join(c for c in title if c.isalnum() or c in ' -_').strip()
    safe_title = safe_title.replace(' ', '_')[:50]
    filename = f"quiz_{safe_title}_{datetime.now().strftime('%Y%m%d_%H%M%S')}.html"
    
    output_path = os.path.expanduser(output_dir)
    os.makedirs(output_path, exist_ok=True)
    file_path = os.path.join(output_path, filename)
    
    # 生成HTML
    html = generate_quiz_html(title, questions)
    
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(html)
    
    print(f"✅ Quiz已生成: {file_path}")
    
    # 启动本地服务
    os.chdir(output_path)
    
    class Handler(http.server.SimpleHTTPRequestHandler):
        def end_headers(self):
            self.send_header('Cache-Control', 'no-store, no-cache, must-revalidate')
            super().end_headers()
    
    print(f"🌐 启动本地服务: http://localhost:{PORT}/{filename}")
    print("按 Ctrl+C 停止服务")
    
    with socketserver.TCPServer(("", PORT), Handler) as httpd:
        httpd.serve_forever()

def main():
    import sys
    
    if len(sys.argv) < 2:
        # Demo模式 - 生成示例Quiz
        demo_questions = [
            {
                "question": "What did the caterpillar become at the end?",
                "options": ["A butterfly", "A moth", "A bee", "A spider"],
                "correct": 0,
                "explanation": "The caterpillar transformed into a beautiful butterfly!"
            },
            {
                "question": "What was the caterpillar's favorite food?",
                "options": ["Leaves", "Flowers", "Fruits", "Honey"],
                "correct": 0,
                "explanation": "Caterpillars love eating leaves!"
            },
            {
                "question": "Where did the caterpillar live?",
                "options": ["In a cocoon", "In a web", "In a burrow", "In a cave"],
                "correct": 0,
                "explanation": "It lived in a cocoon called chrysalis."
            },
            {
                "question": "How many legs does a caterpillar have?",
                "options": ["6", "8", "12", "16"],
                "correct": 2,
                "explanation": "Caterpillars have 16 legs!"
            },
            {
                "question": "What season did the butterfly appear?",
                "options": ["Winter", "Spring", "Summer", "Autumn"],
                "correct": 1,
                "explanation": "The butterfly emerged in spring!"
            }
        ]
        
        print("🎵 生成示例 English Quiz...")
        save_and_serve("The Hungry Caterpillar", demo_questions)
    else:
        # 从命令行参数或stdin读取题目
        try:
            questions_data = json.loads(sys.argv[1])
            title = sys.argv[2] if len(sys.argv) > 2 else "English Quiz"
            save_and_serve(title, questions_data)
        except json.JSONDecodeError:
            print("❌ JSON格式错误")
            sys.exit(1)

if __name__ == "__main__":
    main()
