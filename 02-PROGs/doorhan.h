// прототипы функций
interrupt [TIM1_OVF] void timer1_ovf_isr(void);
void InitMCU(void);
void ReadKey(void);
void ReadSenCL(void);
void ReadSenOP(void);
void SwitchState(void);

#define DR_CL PORTB.0 // выход "закрыть дверь"
#define DR_OP PORTB.1 // выход "открыть дверь"

#define SN_CL PIND.0  // вход "КВ дверь открыта" NC
#define SN_OP PIND.1  // вход "КВ дверь закрыта" NC

#define BT_CL PIND.2  // вход "кнопка закрыть дверь" NO
#define BT_ST PIND.3  // вход "кнопка остановить движение" NC
#define BT_OP PIND.4  // вход "кнопка открыть дверь" NO

#define DEL_ACTION 400 // задержка на срабатывание реле АД [ms]

enum
{
	 key_none = 0,
	 key_bt_cl,
	 key_bt_st,
	 key_bt_op
};
unsigned char sen_sn_cl = 0, sen_sn_op = 0;
#define ONE_PRESS_KEY  150 // задержка на нажатие клавиши или срабатывания датчика
#define ONE_PRESS_SEN 100  // задержка на срабатывание датчика
unsigned char PressedKey;

unsigned char SA; // состояние конечного автомата
#define SA_STOP  0
#define SA_CLOSE 1
#define SA_OPEN  2 
