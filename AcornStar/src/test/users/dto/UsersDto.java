package test.users.dto;

public class UsersDto {
	//필드
	private String id;
	private String pwd;
	private String email;
	private String profile;
	private String uplist;
	private String name;
	private String intro;
	private String friends;
	private String autority;
	private String regdate;
	//디폴트 생성자 
	public UsersDto() {}
	public UsersDto(String id, String pwd, String email, String profile, String uplist, String name, String intro,
			String friends, String autority, String regdate) {
		super();
		this.id = id;
		this.pwd = pwd;
		this.email = email;
		this.profile = profile;
		this.uplist = uplist;
		this.name = name;
		this.intro = intro;
		this.friends = friends;
		this.autority = autority;
		this.regdate = regdate;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getPwd() {
		return pwd;
	}
	public void setPwd(String pwd) {
		this.pwd = pwd;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getProfile() {
		return profile;
	}
	public void setProfile(String profile) {
		this.profile = profile;
	}
	public String getUplist() {
		return uplist;
	}
	public void setUplist(String uplist) {
		this.uplist = uplist;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getIntro() {
		return intro;
	}
	public void setIntro(String intro) {
		this.intro = intro;
	}
	public String getFriends() {
		return friends;
	}
	public void setFriends(String friends) {
		this.friends = friends;
	}
	public String getAutority() {
		return autority;
	}
	public void setAutority(String autority) {
		this.autority = autority;
	}
	public String getRegdate() {
		return regdate;
	}
	public void setRegdate(String regdate) {
		this.regdate = regdate;
	}
}
