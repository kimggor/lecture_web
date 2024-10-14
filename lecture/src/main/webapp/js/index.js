
        function validateStudentId(event) {
            const input = event.target;
            input.value = input.value.replace(/[^0-9]/g, '');
        }

        function validateForm() {
            const studentId = document.getElementById('id').value.trim();
            const password = document.getElementById('pwd').value.trim();

            if (studentId === '') {
                alert('학번을 입력해 주세요.');
                return false; 
            }

            if (password === '') {
                alert('비밀번호를 입력해 주세요.');
                return false; 
            }

            return true; 
        }

		
		
	         function showDiv() {
		    document.querySelectorAll('.info-box').forEach(function(box) {
		        box.style.display = 'none';
		    });
		
		    document.getElementById('boxENG2').style.display = 'none';
		    document.getElementById('boxKOR2').style.display = 'none';
		
		    const selectedLang = document.querySelector('input[name="lang"]:checked').value;
		    
		    if (selectedLang === 'ENG') {
		        document.getElementById('boxENG').style.display = 'block';
		        document.getElementById('boxENG2').style.display = 'block';
		    } else if (selectedLang === 'KOR') {
		        document.getElementById('boxKOR').style.display = 'block';
		        document.getElementById('boxKOR2').style.display = 'block';
		    }
		}
	  
        
        
         function fnNotice() {
            const notiMacro = document.getElementById('notiMacro');
            if (notiMacro.style.display === 'none' || notiMacro.style.display === '') {
                notiMacro.style.display = 'block';
            } else {
                notiMacro.style.display = 'none';
            }
        }
        
