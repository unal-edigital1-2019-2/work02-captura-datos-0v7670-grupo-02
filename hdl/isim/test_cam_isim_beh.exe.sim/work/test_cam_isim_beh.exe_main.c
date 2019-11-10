/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

#include "xsi.h"

struct XSI_INFO xsi_info;



int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    unisims_ver_m_00000000003266096158_2593380106_init();
    unisims_ver_m_00000000004091665089_4058743676_init();
    unisims_ver_m_00000000003084551676_1387874442_init();
    work_m_00000000003109288706_2683070608_init();
    work_m_00000000001964925841_0418314598_init();
    work_m_00000000001433017019_1742765518_init();
    work_m_00000000001064750486_0898626419_init();
    work_m_00000000004134447467_2073120511_init();


    xsi_register_tops("work_m_00000000001064750486_0898626419");
    xsi_register_tops("work_m_00000000004134447467_2073120511");


    return xsi_run_simulation(argc, argv);

}
