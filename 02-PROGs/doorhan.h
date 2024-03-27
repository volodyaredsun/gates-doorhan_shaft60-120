// ��������� �������
interrupt [TIM1_OVF] void timer1_ovf_isr(void);
void InitMCU(void);
void ReadKey(void);
void ReadSenCL(void);
void ReadSenOP(void);
void SwitchState(void);

#define DR_CL PORTB.0 // ����� "������� �����"
#define DR_OP PORTB.1 // ����� "������� �����"

#define SN_CL PIND.0  // ���� "�� ����� �������" NC
#define SN_OP PIND.1  // ���� "�� ����� �������" NC

#define BT_CL PIND.2  // ���� "������ ������� �����" NO
#define BT_ST PIND.3  // ���� "������ ���������� ��������" NC
#define BT_OP PIND.4  // ���� "������ ������� �����" NO

#define DEL_ACTION 400 // �������� �� ������������ ���� �� [ms]

enum
{
	 key_none = 0,
	 key_bt_cl,
	 key_bt_st,
	 key_bt_op
};
unsigned char sen_sn_cl = 0, sen_sn_op = 0;
#define ONE_PRESS_KEY  150 // �������� �� ������� ������� ��� ������������ �������
#define ONE_PRESS_SEN 100  // �������� �� ������������ �������
unsigned char PressedKey;

unsigned char SA; // ��������� ��������� ��������
#define SA_STOP  0
#define SA_CLOSE 1
#define SA_OPEN  2 
