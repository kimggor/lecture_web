package login.ctor;

public class Student {
	private int student_id;
	private String name;
	private String email;
	private String password;
	private int grade;
	private String major;
	private int department_id;
	
	public int getStudent_id() {
		return student_id;
	}
	public void setStudent_id(int student_id) {
		this.student_id = student_id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public int getGrade() {
		return grade;
	}
	public void setGrade(int grade) {
		this.grade = grade;
	}
	public String getMajor() {
		return major;
	}
	public void setMajor(String major) {
		this.major = major;
	}
	public int getDepartment_id() {
		return department_id;
	}
	public void setDepartment_id(int department_id) {
		this.department_id = department_id;
	}
	public Student(int student_id, String name, String email, String password, int grade, String major,
			int department_id) {
		super();
		this.student_id = student_id;
		this.name = name;
		this.email = email;
		this.password = password;
		this.grade = grade;
		this.major = major;
		this.department_id = department_id;
	}
	@Override
	public String toString() {
		return "Student [student_id=" + student_id + ", name=" + name + ", email=" + email + ", password=" + password
				+ ", grade=" + grade + ", major=" + major + ", department_id=" + department_id + "]";
	}
	
	
}
