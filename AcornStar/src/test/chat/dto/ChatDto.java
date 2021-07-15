package test.chat.dto;

public class ChatDto {
	// fields
	private int num;
	private String writer;
	private String content;
	
	// default constructor
	public ChatDto() {
		
	}

	public ChatDto(int num, String writer, String content) {
		super();
		this.num = num;
		this.writer = writer;
		this.content = content;
	}

	public int getNum() {
		return num;
	}

	public void setNum(int num) {
		this.num = num;
	}

	public String getWriter() {
		return writer;
	}

	public void setWriter(String writer) {
		this.writer = writer;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}
	
}
