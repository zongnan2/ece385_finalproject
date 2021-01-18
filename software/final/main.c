/*---------------------------------------------------------------------------
  --      main.c                                                    	   --
  --      Edited by Joseph Ravichandran during Spring 2019        		   --
  --                                                                	   --
  --      Christine Chen                                                   --
  --      Ref. DE2-115 Demonstrations by Terasic Technologies Inc.         --
  --      Fall 2014                                                        --
  --                                                                       --
  --      For use with ECE 385 Lab 8      		                           --
  --      UIUC ECE Department                                              --
  ---------------------------------------------------------------------------*/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <io.h>
#include <fcntl.h>

#include "system.h"
#include "alt_types.h"
#include <unistd.h>  // usleep 
#include "sys/alt_irq.h"

#include "lcp_cmd.h"
#include "lcp_data.h"

#include "altera_up_avalon_usb.h"
#include "altera_up_avalon_usb_ptd.h"
#include "altera_up_avalon_usb_regs.h"
#include "altera_up_avalon_usb_low_level_driver.h"
#include "altera_up_avalon_usb_high_level_driver.h"
#include "altera_up_avalon_usb_mouse_driver.h"

unsigned int alt_up_usb_play_mouse2(alt_up_usb_dev * usb_device, int addr, int port);
unsigned int alt_up_usb_setup2(alt_up_usb_dev * usb_device, int * addr_ptr, int * port_ptr);


int maxmin(int no, int max, int min) {
	if (no > max) { no = max; }
	if (no < min) { no = min; }
	return(no);
}


//----------------------------------------------------------------------------------------//
//
//                                Main function
//
//----------------------------------------------------------------------------------------//
//int main2(void)
//{
//	IO_init();
//
//	/*while(1)
//	{
//		IO_write(HPI_MAILBOX,COMM_EXEC_INT);
//		printf("[ERROR]:routine mailbox data is %x\n",IO_read(HPI_MAILBOX));
//		//UsbWrite(0xc008,0x000f);
//		//UsbRead(0xc008);
//		usleep(10*10000);
//	}*/
//
//	alt_u16 intStat;
//	alt_u16 usb_ctl_val;
//	static alt_u16 ctl_reg = 0;
//	static alt_u16 no_device = 0;
//	alt_u16 fs_device = 0;
////	int keycode = 0;
//	int button_value;
//	alt_u16 px = 320;
//	alt_u16 py = 240;
//	signed char dx = 0;
//	signed char dy = 0;
//	alt_u8 pbutton = 0;
//	alt_u8 toggle = 0;
//	alt_u8 data_size;
//	alt_u8 hot_plug_count;
//	alt_u16 code;
//
//	printf("USB mouse setup...\n\n");
//
//	//----------------------------------------SIE1 initial---------------------------------------------------//
//	USB_HOT_PLUG:
//	UsbSoftReset();
//
//	// STEP 1a:
//	UsbWrite (HPI_SIE1_MSG_ADR, 0);
//	UsbWrite (HOST1_STAT_REG, 0xFFFF);
//
//	/* Set HUSB_pEOT time */
//	UsbWrite(HUSB_pEOT, 600); // adjust the according to your USB device speed
//
//	usb_ctl_val = SOFEOP1_TO_CPU_EN | RESUME1_TO_HPI_EN;// | SOFEOP1_TO_HPI_EN;
//	UsbWrite(HPI_IRQ_ROUTING_REG, usb_ctl_val);
//
//	intStat = A_CHG_IRQ_EN | SOF_EOP_IRQ_EN ;
//	UsbWrite(HOST1_IRQ_EN_REG, intStat);
//	// STEP 1a end
//
//	// STEP 1b begin
//	UsbWrite(COMM_R0,0x0000);//reset time
//	UsbWrite(COMM_R1,0x0000);  //port number
//	UsbWrite(COMM_R2,0x0000);  //r1
//	UsbWrite(COMM_R3,0x0000);  //r1
//	UsbWrite(COMM_R4,0x0000);  //r1
//	UsbWrite(COMM_R5,0x0000);  //r1
//	UsbWrite(COMM_R6,0x0000);  //r1
//	UsbWrite(COMM_R7,0x0000);  //r1
//	UsbWrite(COMM_R8,0x0000);  //r1
//	UsbWrite(COMM_R9,0x0000);  //r1
//	UsbWrite(COMM_R10,0x0000);  //r1
//	UsbWrite(COMM_R11,0x0000);  //r1
//	UsbWrite(COMM_R12,0x0000);  //r1
//	UsbWrite(COMM_R13,0x0000);  //r1
//	UsbWrite(COMM_INT_NUM,HUSB_SIE1_INIT_INT); //HUSB_SIE1_INIT_INT
//	IO_write(HPI_MAILBOX,COMM_EXEC_INT);
//
//	while (!(IO_read(HPI_STATUS) & 0xFFFF) )  //read sie1 msg register
//	{
//	}
//	while (IO_read(HPI_MAILBOX) != COMM_ACK)
//	{
//		printf("[ERROR]:routine mailbox data is %x\n",IO_read(HPI_MAILBOX));
//		goto USB_HOT_PLUG;
//	}
//	// STEP 1b end
//
//	printf("STEP 1 Complete");
//	// STEP 2 begin
//	UsbWrite(COMM_INT_NUM,HUSB_RESET_INT); //husb reset
//	UsbWrite(COMM_R0,0x003c);//reset time
//	UsbWrite(COMM_R1,0x0000);  //port number
//	UsbWrite(COMM_R2,0x0000);  //r1
//	UsbWrite(COMM_R3,0x0000);  //r1
//	UsbWrite(COMM_R4,0x0000);  //r1
//	UsbWrite(COMM_R5,0x0000);  //r1
//	UsbWrite(COMM_R6,0x0000);  //r1
//	UsbWrite(COMM_R7,0x0000);  //r1
//	UsbWrite(COMM_R8,0x0000);  //r1
//	UsbWrite(COMM_R9,0x0000);  //r1
//	UsbWrite(COMM_R10,0x0000);  //r1
//	UsbWrite(COMM_R11,0x0000);  //r1
//	UsbWrite(COMM_R12,0x0000);  //r1
//	UsbWrite(COMM_R13,0x0000);  //r1
//
//	IO_write(HPI_MAILBOX,COMM_EXEC_INT);
//
//	while (IO_read(HPI_MAILBOX) != COMM_ACK)
//	{
//		printf("[ERROR]:routine mailbox data is %x\n",IO_read(HPI_MAILBOX));
//		goto USB_HOT_PLUG;
//	}
//	// STEP 2 end
//
//	ctl_reg = USB1_CTL_REG;
//	no_device = (A_DP_STAT | A_DM_STAT);
//	fs_device = A_DP_STAT;
//	usb_ctl_val = UsbRead(ctl_reg);
//
//	if (!(usb_ctl_val & no_device))
//	{
//		for(hot_plug_count = 0 ; hot_plug_count < 5 ; hot_plug_count++)
//		{
//			usleep(5*1000);
//			usb_ctl_val = UsbRead(ctl_reg);
//			if(usb_ctl_val & no_device) break;
//		}
//		if(!(usb_ctl_val & no_device))
//		{
//			printf("\n[INFO]: no device is present in SIE1!\n");
//			printf("[INFO]: please insert a USB Mouse in SIE1!\n");
//			while (!(usb_ctl_val & no_device))
//			{
//				usb_ctl_val = UsbRead(ctl_reg);
//				if(usb_ctl_val & no_device)
//					goto USB_HOT_PLUG;
//
//				usleep(2000);
//			}
//		}
//	}
//	else
//	{
//		/* check for low speed or full speed by reading D+ and D- lines */
//		if (usb_ctl_val & fs_device)
//		{
//			printf("[INFO]: full speed device\n");
//		}
//		else
//		{
//			printf("[INFO]: low speed device\n");
//		}
//	}
//
//
//
//	// STEP 3 begin
//	//------------------------------------------------------set address -----------------------------------------------------------------
//	UsbSetAddress();
//
//	while (!(IO_read(HPI_STATUS) & HPI_STATUS_SIE1msg_FLAG) )  //read sie1 msg register
//	{
//		UsbSetAddress();
//		usleep(10*1000);
//	}
//
//	UsbWaitTDListDone();
//
//	IO_write(HPI_ADDR,0x0506); // i
//	printf("[ENUM PROCESS]:step 3 TD Status Byte is %x\n",IO_read(HPI_DATA));
//
//	IO_write(HPI_ADDR,0x0508); // n
//	usb_ctl_val = IO_read(HPI_DATA);
//	printf("[ENUM PROCESS]:step 3 TD Control Byte is %x\n",usb_ctl_val);
//	while (usb_ctl_val != 0x03) // retries occurred
//	{
//		usb_ctl_val = UsbGetRetryCnt();
//
//		goto USB_HOT_PLUG;
//	}
//
//	printf("------------[ENUM PROCESS]:set address done!---------------\n");
//
//	// STEP 4 begin
//	//-------------------------------get device descriptor-1 -----------------------------------//
//	// TASK: Call the appropriate function for this step.
//	UsbGetDeviceDesc1(); 	// Get Device Descriptor -1
//
//	//usleep(10*1000);
//	while (!(IO_read(HPI_STATUS) & HPI_STATUS_SIE1msg_FLAG) )  //read sie1 msg register
//	{
//		// TASK: Call the appropriate function again if it wasn't processed successfully.
//		UsbGetDeviceDesc1();
//		usleep(10*1000);
//	}
//
//	UsbWaitTDListDone();
//
//	IO_write(HPI_ADDR,0x0506);
//	printf("[ENUM PROCESS]:step 4 TD Status Byte is %x\n",IO_read(HPI_DATA));
//
//	IO_write(HPI_ADDR,0x0508);
//	usb_ctl_val = IO_read(HPI_DATA);
//	printf("[ENUM PROCESS]:step 4 TD Control Byte is %x\n",usb_ctl_val);
//	while (usb_ctl_val != 0x03)
//	{
//		usb_ctl_val = UsbGetRetryCnt();
//
//		// Fatal problem; try again
//		printf ("Encountered Fatal Error, restarting\n");
//		goto USB_HOT_PLUG;
//	}
//
//	printf("---------------[ENUM PROCESS]:get device descriptor-1 done!-----------------\n");
//
//
//	//--------------------------------get device descriptor-2---------------------------------------------//
//	//get device descriptor
//	// TASK: Call the appropriate function for this step.
//	UsbGetDeviceDesc2(); 	// Get Device Descriptor -2
//
//	//if no message
//	while (!(IO_read(HPI_STATUS) & HPI_STATUS_SIE1msg_FLAG) )  //read sie1 msg register
//	{
//		//resend the get device descriptor
//		//get device descriptor
//		// TASK: Call the appropriate function again if it wasn't processed successfully.
//		UsbGetDeviceDesc2();
//		usleep(10*1000);
//	}
//
//	UsbWaitTDListDone();
//
//	IO_write(HPI_ADDR,0x0506);
//	printf("[ENUM PROCESS]:step 4 TD Status Byte is %x\n",IO_read(HPI_DATA));
//
//	IO_write(HPI_ADDR,0x0508);
//	usb_ctl_val = IO_read(HPI_DATA);
//	printf("[ENUM PROCESS]:step 4 TD Control Byte is %x\n",usb_ctl_val);
//	while (usb_ctl_val != 0x03)
//	{
//		usb_ctl_val = UsbGetRetryCnt();
//
//		// Fatal problem; try again
//		printf ("Encountered Fatal Error, restarting\n");
//		goto USB_HOT_PLUG;
//	}
//
//	printf("------------[ENUM PROCESS]:get device descriptor-2 done!--------------\n");
//
//
//	// STEP 5 begin
//	//-----------------------------------get configuration descriptor -1 ----------------------------------//
//	// TASK: Call the appropriate function for this step.
//	UsbGetConfigDesc1(); 	// Get Configuration Descriptor -1
//
//	//if no message
//	while (!(IO_read(HPI_STATUS) & HPI_STATUS_SIE1msg_FLAG) )  //read sie1 msg register
//	{
//		//resend the get device descriptor
//		//get device descriptor
//
//		// TASK: Call the appropriate function again if it wasn't processed successfully.
//		UsbGetConfigDesc1();
//		usleep(10*1000);
//	}
//
//	UsbWaitTDListDone();
//
//	IO_write(HPI_ADDR,0x0506);
//	printf("[ENUM PROCESS]:step 5 TD Status Byte is %x\n",IO_read(HPI_DATA));
//
//	IO_write(HPI_ADDR,0x0508);
//	usb_ctl_val = IO_read(HPI_DATA);
//	printf("[ENUM PROCESS]:step 5 TD Control Byte is %x\n",usb_ctl_val);
//	while (usb_ctl_val != 0x03)
//	{
//		usb_ctl_val = UsbGetRetryCnt();
//
//		// Fatal problem; try again
//		printf ("Encountered Fatal Error, restarting\n");
//		goto USB_HOT_PLUG;
//	}
//	printf("------------[ENUM PROCESS]:get configuration descriptor-1 pass------------\n");
//
//	// STEP 6 begin
//	//-----------------------------------get configuration descriptor-2------------------------------------//
//	//get device descriptor
//	// TASK: Call the appropriate function for this step.
//	UsbGetConfigDesc2(); 	// Get Configuration Descriptor -2
//
//	usleep(100*1000);
//	//if no message
//	while (!(IO_read(HPI_STATUS) & HPI_STATUS_SIE1msg_FLAG) )  //read sie1 msg register
//	{
//		// TASK: Call the appropriate function again if it wasn't processed successfully.
//		UsbGetConfigDesc2();
//		usleep(10*1000);
//	}
//
//	UsbWaitTDListDone();
//
//	IO_write(HPI_ADDR,0x0506);
//	printf("[ENUM PROCESS]:step 6 TD Status Byte is %x\n",IO_read(HPI_DATA));
//
//	IO_write(HPI_ADDR,0x0508);
//	usb_ctl_val = IO_read(HPI_DATA);
//	printf("[ENUM PROCESS]:step 6 TD Control Byte is %x\n",usb_ctl_val);
//	while (usb_ctl_val != 0x03)
//	{
//		usb_ctl_val = UsbGetRetryCnt();
//
//		// Fatal problem; try again
//		printf ("Encountered Fatal Error, restarting\n");
//		goto USB_HOT_PLUG;
//	}
//
//
//	printf("-----------[ENUM PROCESS]:get configuration descriptor-2 done!------------\n");
//
//
//	// ---------------------------------get device info---------------------------------------------//
//
//	// TASK: Write the address to read from the memory for byte 7 of the interface descriptor to HPI_ADDR.
//	IO_write(HPI_ADDR,0x056c);
//	code = IO_read(HPI_DATA);
//	code = code & 0x0ff;
//	printf("\ncode = %x\n", code);
//
//	if (code == 0x02)
//	{
//		printf("\n[INFO]:check TD rec data7 \n[INFO]:Mouse Detected!!!\n\n");
//	}
//	else
//	{
//		printf("\n[INFO]:Mouse Not Detected!!! \n\n");
//	}
//
//	// TASK: Write the address to read from the memory for the endpoint descriptor to HPI_ADDR.
//
//	//TODO: Check if this is needed?
//	IO_write(HPI_ADDR,0x0576);
//	IO_write(HPI_DATA,0x073F);
//	IO_write(HPI_DATA,0x8105);
//	IO_write(HPI_DATA,0x0003);
//	IO_write(HPI_DATA,0x0008);
//	IO_write(HPI_DATA,0xAC0A);
//	UsbWrite(HUSB_SIE1_pCurrentTDPtr,0x0576); //HUSB_SIE1_pCurrentTDPtr
//
//	IO_write(HPI_ADDR,0x057a);
//	data_size = (IO_read(HPI_DATA)>>8)&0x0ff;
//	//data_size = 0x08;//(IO_read(HPI_DATA))&0x0ff;
//	//UsbPrintMem();
////	IO_write(HPI_ADDR,0x057c);
////	data_size = (IO_read(HPI_DATA))&0x0ff;
//	printf("[ENUM PROCESS]:data packet size is %d\n",data_size);
//	// STEP 7 begin
//	//------------------------------------set configuration -----------------------------------------//
//	// TASK: Call the appropriate function for this step.
//	UsbSetConfig();		// Set Configuration
//
//	while (!(IO_read(HPI_STATUS) & HPI_STATUS_SIE1msg_FLAG) )  //read sie1 msg register
//	{
//		// TASK: Call the appropriate function again if it wasn't processed successfully.
//		UsbSetConfig();		// Set Configuration
//		usleep(10*1000);
//	}
//
//	UsbWaitTDListDone();
//
//	IO_write(HPI_ADDR,0x0506);
//	printf("[ENUM PROCESS]:step 7 TD Status Byte is %x\n",IO_read(HPI_DATA));
//
//	IO_write(HPI_ADDR,0x0508);
//	usb_ctl_val = IO_read(HPI_DATA);
//	printf("[ENUM PROCESS]:step 7 TD Control Byte is %x\n",usb_ctl_val);
//	while (usb_ctl_val != 0x03)
//	{
//		usb_ctl_val = UsbGetRetryCnt();
//
//		// Fatal problem; try again
//		printf ("Encountered Fatal Error, restarting\n");
//		goto USB_HOT_PLUG;
//	}
//
//	printf("------------[ENUM PROCESS]:set configuration done!-------------------\n");
//
//	//----------------------------------------------class request out ------------------------------------------//
//	// TASK: Call the appropriate function for this step.
//	UsbClassRequest();
//
//	while (!(IO_read(HPI_STATUS) & HPI_STATUS_SIE1msg_FLAG) )  //read sie1 msg register
//	{
//		// TASK: Call the appropriate function again if it wasn't processed successfully.
//		UsbClassRequest();
//		usleep(10*1000);
//	}
//
//	UsbWaitTDListDone();
//
//	IO_write(HPI_ADDR,0x0506);
//	printf("[ENUM PROCESS]:step 8 TD Status Byte is %x\n",IO_read(HPI_DATA));
//
//	IO_write(HPI_ADDR,0x0508);
//	usb_ctl_val = IO_read(HPI_DATA);
//	printf("[ENUM PROCESS]:step 8 TD Control Byte is %x\n",usb_ctl_val);
//	while (usb_ctl_val != 0x03)
//	{
//		usb_ctl_val = UsbGetRetryCnt();
//
//		// Fatal problem; try again
//		printf ("Encountered Fatal Error, restarting\n");
//		goto USB_HOT_PLUG;
//	}
//
//
//	printf("------------[ENUM PROCESS]:class request out done!-------------------\n");
//
//	// STEP 8 begin
//	//----------------------------------get descriptor(class 0x21 = HID) request out --------------------------------//
//	// TASK: Call the appropriate function for this step.
//	UsbGetHidDesc();
//
//	while (!(IO_read(HPI_STATUS) & HPI_STATUS_SIE1msg_FLAG) )  //read sie1 msg register
//	{
//		// TASK: Call the appropriate function again if it wasn't processed successfully.
//		UsbGetHidDesc();
//		usleep(10*1000);
//	}
//
//	UsbWaitTDListDone();
//
//	IO_write(HPI_ADDR,0x0506);
//	printf("[ENUM PROCESS]:step 8 TD Status Byte is %x\n",IO_read(HPI_DATA));
//
//	IO_write(HPI_ADDR,0x0508);
//	usb_ctl_val = IO_read(HPI_DATA);
//	printf("[ENUM PROCESS]:step 8 TD Control Byte is %x\n",usb_ctl_val);
//	while (usb_ctl_val != 0x03)
//	{
//		usb_ctl_val = UsbGetRetryCnt();
//
//		// Fatal problem; try again
//		printf ("Encountered Fatal Error, restarting\n");
//		goto USB_HOT_PLUG;
//	}
//
//	printf("------------[ENUM PROCESS]:get descriptor (class 0x21) done!-------------------\n");
//
//	// STEP 9 begin
//	//-------------------------------get descriptor (class 0x22 = report)-------------------------------------------//
//	// TASK: Call the appropriate function for this step.
//	UsbGetReportDesc();
//	//if no message
//	while (!(IO_read(HPI_STATUS) & HPI_STATUS_SIE1msg_FLAG) )  //read sie1 msg register
//	{
//		// TASK: Call the appropriate function again if it wasn't processed successfully.
//		UsbGetReportDesc();
//		usleep(10*1000);
//	}
//
//	UsbWaitTDListDone();
//
//	IO_write(HPI_ADDR,0x0506);
//	printf("[ENUM PROCESS]: step 9 TD Status Byte is %x\n",IO_read(HPI_DATA));
//
//	IO_write(HPI_ADDR,0x0508);
//	usb_ctl_val = IO_read(HPI_DATA);
//	printf("[ENUM PROCESS]: step 9 TD Control Byte is %x\n",usb_ctl_val);
//	while (usb_ctl_val != 0x03)
//	{
//		usb_ctl_val = UsbGetRetryCnt();
//
//		// Fatal problem; try again
//		printf ("Encountered Fatal Error, restarting\n");
//		goto USB_HOT_PLUG;
//	}
//
//	printf("---------------[ENUM PROCESS]:get descriptor (class 0x22) done!----------------\n");
//
//
//
//	//-----------------------------------get mouse values------------------------------------------------//
//	usleep(10000);
//	while(1)
//	{
//		toggle++;
//		IO_write(HPI_ADDR,0x0500); //the start address
//		//data phase IN-1
//		IO_write(HPI_DATA,0x051c); //500
//
//		if (data_size == 8) {
//			IO_write(HPI_DATA, 0x0006);
//		} else {
//			IO_write(HPI_DATA,0x000f & data_size);//2 data length
//		}
//
//		IO_write(HPI_DATA,0x0291);//4 //endpoint 1
//		if(toggle%2)
//		{
//			IO_write(HPI_DATA,0x0001);//6 //data 1
//		}
//		else
//		{
//			IO_write(HPI_DATA,0x0041);//6 //data 1
//		}
//		IO_write(HPI_DATA,0x0013);//8
//		IO_write(HPI_DATA,0x0000);//a
//		UsbWrite(HUSB_SIE1_pCurrentTDPtr,0x0500); //HUSB_SIE1_pCurrentTDPtr
//
//		while (!(IO_read(HPI_STATUS) & HPI_STATUS_SIE1msg_FLAG) )  //read sie1 msg register
//		{
//			IO_write(HPI_ADDR,0x0500); //the start address
//			//data phase IN-1
//			IO_write(HPI_DATA,0x051c); //500
//
//			if (data_size == 8) {
//				IO_write(HPI_DATA, 0x0006);
//			} else {
//				IO_write(HPI_DATA,0x000f & data_size);//2 data length
//			}
//
//			IO_write(HPI_DATA,0x0291);//4 //endpoint 1
//			if(toggle%2)
//			{
//				IO_write(HPI_DATA,0x0001);//6 //data 1
//			}
//			else
//			{
//				IO_write(HPI_DATA,0x0041);//6 //data 1
//			}
//			IO_write(HPI_DATA,0x0013);//8
//			IO_write(HPI_DATA,0x0000);//
//			UsbWrite(HUSB_SIE1_pCurrentTDPtr,0x0500); //HUSB_SIE1_pCurrentTDPtr
//			usleep(10*1000);
//		}//end while
//
//		usb_ctl_val = UsbWaitTDListDone();
////	    usb_ctl_val = IORD(CY7C67200_BASE,HPI_DATA); // Maybe uncomment
//
//		if (usb_ctl_val != 0x03){
//			pbutton = 0;
//			dx = 0;
//			dy = 0;
//			button_value = 0;
//		} else {
//			if (data_size != 8) {
//				IO_write(HPI_ADDR, 0x051c);
//				button_value = IO_read(HPI_DATA);
//
//				if ((button_value & 0x00ff) == 0x0001) {
//					pbutton = 1; // Left button
//				} else if ((button_value & 0x00ff) == 0x0002) {
//					pbutton = 2;
//				} else {
//					pbutton = 0;
//				}
//				if((signed char)((button_value>>8) & 0x00ff) != 0)
//				{
//					if ((signed char)((button_value >> 8) & 0x00ff) == dx) {
//						dx = 0;
//					} else {
//						dx = (signed char)((button_value >> 8) & 0x00ff);
//					}
//				}
//
//				button_value = IO_read(HPI_DATA);
//				if (button_value & 0x00ff) {
//					if ((signed char)(button_value & 0x00ff) == dy) {
//						dy = 0;
//					} else {
//						dy = (signed char)(button_value & 0xff);
//					}
//				}
//			} else {
//				IO_write(HPI_ADDR, 0x051c);
//				button_value = IO_read(HPI_DATA);
//
//				if (((button_value >> 8) & 0x00ff) == 0x0001) {
//					pbutton = 1;
//				} else if (((button_value >> 8) & 0x00ff) == 0x0002) {
//					pbutton = 2;
//				} else {
//					pbutton = 0;
//				}
//
//				button_value = IO_read(HPI_DATA);
//				if ((signed char) ((button_value >> 8) & 0x00ff) != 0) {
//					if ((signed char) ((button_value >> 8) & 0x00ff) == dy) {
//						dy = 0;
//					} else {
//						dy = (signed char) ((button_value >> 8) & 0x00ff);
//					}
//				}
//
//				if (button_value & 0x00ff) {
//					if ((signed char)(button_value & 0x00ff) == dx) {
//						dx = 0;
//					} else {
//						dx = (signed char) ((button_value & 0x00ff));
//					}
//				}
//			}
//		}
//
//		px = px + dx;
//		py = py + dy;
//
//		px = maxmin(px, 639, 0);
//		py = maxmin(py, 479, 0);
//
//		printf("\n Dx: %d, Dy: %d\n", dx, dy);
//
//		printf("\n Buttons Pressed: %01x, X Value: %d, Y Value: %d\n", pbutton, px, py);
//
//		*pbutton_base = pbutton;
//		*mousex_base = px;
//		*mousey_base = py;
//
//
//
////		// The first two keycodes are stored in 0x051E. Other keycodes are in
////		// subsequent addresses.
////		keycode = UsbRead(0x051e);
////		printf("\nfirst two keycode values are %04x\n",keycode);
////		// We only need the first keycode, which is at the lower byte of keycode.
////		// Send the keycode to hardware via PIO.
////		*keycode_base = keycode & 0xff;
////
////		usleep(200);//usleep(5000);
////		usb_ctl_val = UsbRead(ctl_reg);
//
//		if(!(usb_ctl_val & no_device))
//		{
//			//USB hot plug routine
//			for(hot_plug_count = 0 ; hot_plug_count < 7 ; hot_plug_count++)
//			{
//				usleep(5*1000);
//				usb_ctl_val = UsbRead(ctl_reg);
//				if(usb_ctl_val & no_device) break;
//			}
//			if(!(usb_ctl_val & no_device))
//			{
//				printf("\n[INFO]: the mouse has been removed!!! \n");
//				printf("[INFO]: please insert again!!! \n");
//			}
//		}
//
//		while (!(usb_ctl_val & no_device))
//		{
//
//			usb_ctl_val = UsbRead(ctl_reg);
//			usleep(5*1000);
//			usb_ctl_val = UsbRead(ctl_reg);
//			usleep(5*1000);
//			usb_ctl_val = UsbRead(ctl_reg);
//			usleep(5*1000);
//
//			if(usb_ctl_val & no_device)
//				goto USB_HOT_PLUG;
//
//			usleep(200);
//		}
//
//	}//end while
//
//	return 0;
//}

//unsigned int alt_up_usb_play_mouse2(alt_up_usb_dev * usb_device, int addr, int port) {
//    printf("ISP1362 USB Mouse Demo.....\n");
//    alt_up_usb_mouse_setup(usb_device, addr, port);
//    alt_up_usb_mouse_packet usb_mouse_packet;
//    usb_mouse_packet.x_movement = 0;
//    usb_mouse_packet.y_movement = 0;
//    usb_mouse_packet.buttons = 0;
//
//    unsigned int pX = 320, pY = 240;
//
//    do {
//        pX = pX + usb_mouse_packet.x_movement;
//        pY = pY + usb_mouse_packet.y_movement;
//        if (pX > 639) {
//            pX = 639;
//        }
//        if (pX < 0) {
//            pX = 0;
//        }
//        if (pY > 479) {
//            pY = 479;
//        }
//        if (pY < 0) {
//            pY = 0;
//        }
//
////        alt_up_parallel_port_dev * Green_LEDs_dev;
////        alt_up_parallel_port_dev * Red_LEDs_dev;
////        alt_up_parallel_port_dev * HEX3_HEX0_dev;
////        Green_LEDs_dev = alt_up_parallel_port_open_dev("/dev/Green_LEDs");
////        Red_LEDs_dev = alt_up_parallel_port_open_dev("/dev/Red_LEDs");
////        HEX3_HEX0_dev = alt_up_parallel_port_open_dev("/dev/HEX3_HEX0");
////        alt_up_parallel_port_write_data(Red_LEDs_dev, pX);
////        alt_up_parallel_port_write_data(Green_LEDs_dev, pY);
//        if ((usb_mouse_packet.buttons & 0x1) == 1) { //left button
//        	printf("Left button pressed!\n");
////            alt_up_parallel_port_write_data(HEX3_HEX0_dev, 0x3f0000);
//        }
//        if (((usb_mouse_packet.buttons & 0x2) >> 1) == 1) { //right button
//        	printf("Right button pressed!\n");
////            alt_up_parallel_port_write_data(HEX3_HEX0_dev, 0x3f);
//        }
//        if (((usb_mouse_packet.buttons & 0x4) >> 2) == 1) { //center button
//        	printf("Center button pressed!\n");
////        alt_up_parallel_port_write_data(HEX3_HEX0_dev, 0x3f00);
//        }
//
//        usb_mouse_packet.x_movement = 0;
//        usb_mouse_packet.y_movement = 0;
//        usb_mouse_packet.buttons = 0;
//    // Polling and get the data from the mouse
//    } while (alt_up_usb_retrieve_mouse_packet(usb_device, &usb_mouse_packet) != ALT_UP_USB_MOUSE_NOT_CONNECTED);
//    printf("Mouse Not Detected\n");
//    return 0;
//}
//
//unsigned int alt_up_usb_setup2(alt_up_usb_dev * usb_device, int * addr_ptr, int * port_ptr) {
//    unsigned int rbuf[128];
//    unsigned int mycode;
//    unsigned int iManufacturer, iProduct;
//    unsigned int status;
//    unsigned int new_port1_addr, new_port2_addr, print_port_info;
//    unsigned int extra, HID;
//    // 1 means port1 is connected; 2 means port2 is connected;
//    *port_ptr = -1;
//    HID = -1;
//    while (1) {
//        // Configure and Set up the controls of the ATL buffer
//    	printf("Beginning of setup\n");
//        alt_up_usb_reset(usb_device);
//        alt_up_usb_hc_initialize_defaults(usb_device);
//
//        // Change the HC to operational state and Enable the port
//        alt_up_usb_hc_set_operational(usb_device);
//        alt_up_usb_enable_ports(usb_device);
//
//        // Suspend the host controller, if the system doesn’t need it
//        alt_up_usb_hc_reg_write_16(usb_device, ALT_UP_USB_HcControl, 0x6c0);
//        alt_up_usb_hc_reg_write_16(usb_device, ALT_UP_USB_HcuPInterrupt, 0x1a9);
//
//        // Assign new addresses for port 1 and port 2, maximum addr number is 7
//        new_port1_addr = 1;
//        new_port2_addr = 2;
//        print_port_info = 0;
//        status = alt_up_usb_assign_address(usb_device, new_port1_addr, new_port2_addr, print_port_info);
//
//        // Enable ALT_IRQ and HC suspended
//        alt_up_usb_hc_reg_write_16(usb_device, ALT_UP_USB_HcuPInterruptEnable, 0x120);
//        *port_ptr = -1;
//        extra = 0;
//        printf("Status: %08x\n");
//        if ((status & 0x0001) != 0) {//port 2 active
//        	*port_ptr = 2;
//            *addr_ptr = new_port2_addr;
//        } else if ((status & 0x0100) != 0) {//port 1 active
//            *port_ptr = 1;
//            *addr_ptr = new_port1_addr;
//        }
//        printf("Port ptr: %08x\n", *port_ptr);
//        if (*port_ptr != -1) {
//            // Check port for device
//            mycode = alt_up_usb_get_control(usb_device, rbuf, *addr_ptr, 'D', extra, *port_ptr);
//            printf("Mycode: %08x\n", mycode);
//            if (mycode == 0x0300) {
//                iManufacturer = rbuf[7]&0xFF;
//                iProduct = (rbuf[7]&0xFF00) >> 8;
//                alt_up_usb_addr_info(*addr_ptr, 'W', 'O', iManufacturer);
//                alt_up_usb_addr_info(*addr_ptr, 'W', 'P', iProduct);
//                mycode = alt_up_usb_get_control(usb_device, rbuf, *addr_ptr, 'H', alt_up_usb_addr_info(*addr_ptr, 'R', 'P', 0), *port_ptr);
//
//                HID = *(rbuf + 1);
//                if (HID == 0x0209) { //it must be 0x0209, if connected device is a mouse
//                    printf("\nMouse Detected...\n");
//                } else if (HID == 0x0609) { //it must be 0x0609, if connected device is a keyboard
//                    printf("\nKeyboard Detected...\n");
//                } else {
//                    printf("\nUSB Device with HID 0x%04x Detected...\n", HID);
//                }
//            return HID;
//            }
//        }
//
//        {
//            volatile int usleep;
//            for (usleep = 0; usleep < 20000; usleep++);
//        }
//    }
//}

int main(void) {
	// 1.Open the USB device
	alt_up_usb_dev * usb_device;
	usb_device = alt_up_usb_open_dev("/dev/USB");
	if (usb_device != NULL) {
		printf("usb_device->base %08x, please check if this matches the USB’s base address in Qsys\n", usb_device->base);
		unsigned int mycode;
		int port = -1;
		int addr = -1;
		int config = -1;
		int hid = -1;
		int x = 0;
		int y = 0;
		int l_button = 0;
		int r_button = 0;
		int m_button = 0;
		alt_up_usb_mouse_packet packet;

		printf("Begin USB setup\n");
		hid = alt_up_usb_setup(usb_device, &addr, &port);
		printf("HID: %08x\n", hid);
		if (port != -1 && hid == 0x0209) {
			alt_up_usb_set_config(usb_device, addr, port, 1);
			alt_up_usb_mouse_setup(usb_device, addr, port);
			while (1) {
				alt_up_usb_retrieve_mouse_packet(usb_device, &packet);
				x += packet.x_movement;
				y += packet.y_movement;
				l_button = packet.buttons && 0x01;
				r_button = packet.buttons && 0x02;
				m_button = packet.buttons && 0x04;
				printf("X: %d, Y: %d, Buttons: %08x\n", x, y, packet.buttons);
			}
		}
	}else {
		printf("Error: could not open USB device\n");
	}
	return 0;
}
