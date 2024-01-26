#include <iostream>
#include <cstring>
#include <fstream>
#include <string>
#include <sstream>

using namespace std;

char *DecToBin(string nums, unsigned bit);

int main()
{
    ifstream inFile("Assembly.txt");
    ofstream outFile;
    outFile.open(("Binary.txt"));
    string line, str_null= "000";
    string str[10];	
	string temp;
    while(getline(inFile, line))
    {
        char *token = std::strtok(&line[0], " ,()");
            int i=0;
			//printf("1 %s",&line[0]);

            while (token != NULL) 
			{
				str[i] = token;
				//if(token != NULL)
				//{
				temp = token;
				//}
				token = std::strtok(NULL, " ,()");
				i++;
			}
			if(i!=0){
			if(str[0] =="ah") {outFile << "00011001000"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // ah - Add Halfword
			else if(str[0] =="ahi") {outFile << "00011101000"<<DecToBin(str[3], 10)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // ahi - Add Halfword Immediate
			else if(str[0] =="a") {outFile << "00011000000"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  //  a - Add Word
			else if(str[0] =="ai") {outFile << "00011100"<<DecToBin(str[3], 10)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // ai - Add Word Immediate
			else if(str[0] =="sfh") {outFile << "00001001000"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // sfh - Subtract from halfword
			else if(str[0] =="sfhi") {outFile << "00001101"<<DecToBin(str[3], 10)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // sfhi - Subtract from halfword immediate
			else if(str[0] =="sf") {outFile << "00001000000"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  //   sf - Subtract from Word
			else if(str[0] =="sfi") {outFile << "00001100"<<DecToBin(str[3], 10)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  //  sfi - Subtract from Word Immediate
			else if(str[0] =="mpy") {outFile << "01111000100"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  //  mpy - Multiply
			else if(str[0] =="mpyu") {outFile << "01111001100"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  //  mpyu - Multiply Unsigned
			else if(str[0] =="mpyi") {outFile << "01110100"<<DecToBin(str[3], 10)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  //  mpyi - Multiply Immediate	
			else if(str[0] =="mpya") {outFile << "1100"<<DecToBin(str[1], 7)<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[4], 7)<<endl;}  //  mpya - Multiply and Add
			else if(str[0] =="clz") {outFile << "01010100101"<<DecToBin(str_null, 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // clz - count leading zeros
			else if(str[0] =="fsmbi") {outFile << "001100101"<<DecToBin(str[2],16)<<DecToBin(str[1], 7)<<endl;}  // fsmbi FORM_SELECT_MASK_BYTES_IMMEDIATE
			else if(str[0] =="fsmb") {outFile << "00110110110"<<DecToBin(str_null, 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;} // fsmb FORM_SELECT_MASK_BYTES
			else if(str[0] =="fsmh") {outFile << "00110110101"<<DecToBin(str_null, 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;} // fsmh FORM_SELECT_MASK_HALFWORD
			else if(str[0] =="fsm") {outFile << "00110110100"<<DecToBin(str_null, 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;} //  fsm FORM_SELECT_MASK_WORD
			else if(str[0] =="and") {outFile << "00011000001"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // and - And
			else if(str[0] =="andhi") {outFile << "00010101"<<DecToBin(str[3], 10)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // andhi - And half WORD Immediate
			else if(str[0] =="andi") {outFile << "00010100"<<DecToBin(str[3], 10)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // andi - And WORD Immediate
			else if(str[0] =="or") {outFile << "00001000001"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // or - Or
			else if(str[0] =="orbi") {outFile << "00000110"<<DecToBin(str[3], 10)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // orbi - Or byte Immediate	
			else if(str[0] =="orhi") {outFile << "00000101"<<DecToBin(str[3], 10)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // orhi - Or half Word Immediate	
			else if(str[0] =="ori") {outFile << "00000100"<<DecToBin(str[3], 10)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // ori - Or Word Immediate		
			else if(str[0] =="nor") {outFile << "00001001001"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // nor - Nor
			else if(str[0] =="xor") {outFile << "01001000001"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // xor - Exclusive Or
			else if(str[0] =="xorbi") {outFile << "01000110"<<DecToBin(str[3], 10)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // xorbi - Exclusive Or Byte Immediate
			else if(str[0] =="xorhi") {outFile << "01000101"<<DecToBin(str[3], 10)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // xorhi - Exclusive Or half Word Immediate
			else if(str[0] =="xori") {outFile << "01000100"<<DecToBin(str[3], 10)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // xori - Exclusive Or Word Immediate
			else if(str[0] =="fa") {outFile << "01011000100"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // fa - Floating Add
			else if(str[0] =="fs") {outFile << "01011000101"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // fs - Floating Subtract
			else if(str[0] =="fm") {outFile << "01011000110"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // fm - Floating Multiply
			else if(str[0] =="fma") {outFile << "1110"<<DecToBin(str[1], 7)<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[4], 7)<<endl;}  //fma - Floating Multiply and Add
			else if(str[0] =="fms") {outFile << "1111"<<DecToBin(str[1], 7)<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[4], 7)<<endl;}  // fms - Floating Multiply and Subtract
			else if(str[0] =="eqv") {outFile << "01001001001"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // eqv - EQUIVALENT
			else if(str[0] =="shlh") {outFile << "00001011111"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // shlh - SHIFT_LEFT_HALFWORD
			else if(str[0] =="shlhi") {outFile << "00001111111"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // shlhi - SHIFT_LEFT_HALFWORD_IMMEDIATE
			else if(str[0] =="shl") {outFile << "00001011011"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // shl - SHIFT_LEFT_WORD
			else if(str[0] =="shli") {outFile << "00001111011"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // shli - SHIFT_LEFT_WORD_IMMEDIATE
			else if(str[0] =="roth") {outFile << "00001011100"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // roth - ROTATE_HALFWORD
			else if(str[0] =="rothi") {outFile << "00001111100"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // rothi - ROTATE_HALFWORD_IMMEDIATE
			else if(str[0] =="rot") {outFile << "00001011000"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // rot - Rotate Word
			else if(str[0] =="roti") {outFile << "00001111000"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // roti - ROTATE_WORD_IMMEDIATE
			else if(str[0] =="rothm") {outFile << "00001011101"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // rothm - Rotate and Mask halfWord
			else if(str[0] =="rothmi") {outFile << "00001111101"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // rothmi - Rotate and Mask halfWord immediate
			else if(str[0] =="cntb") {outFile << "01010110100"<<DecToBin(str_null, 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // cntb - Count Ones in Bytes          
			else if(str[0] =="avgb") {outFile << "00011010011"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // avgb - Average Bytes
			else if(str[0] =="absdb") {outFile << "00001010011"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // absdb - Absolute Differences of Bytes
			else if(str[0] =="sumb") {outFile << "01001010011"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  //  sumb - Sum Bytes into Halfwords
			else if(str[0] =="ceqh") {outFile << "01111001000"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // ceqh - Compare Equal halfWord
			else if(str[0] =="ceqhi") {outFile << "01111101"<<DecToBin(str[3], 10)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  //  ceqhi - Compare Equal halfWord Immediate
			else if(str[0] =="ceq") {outFile << "01111000000"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // ceq - Compare Equal Word
			else if(str[0] =="ceqi") {outFile << "01111100"<<DecToBin(str[3], 10)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // ceqi - Compare Equal Word Immediate
			else if(str[0] =="cgth") {outFile << "01001001000"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // cgth - Compare Greater Than halfword		
			else if(str[0] =="cgthi") {outFile << "01001101"<<DecToBin(str[3], 10)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // cgthi - Compare Greater Than halfWord Immediate
			else if(str[0] =="cgt") {outFile << "01001000000"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // cgt - Compare Greater Than word
			else if(str[0] =="cgti") {outFile << "01001100"<<DecToBin(str[3], 10)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // cgti - Compare Greater Than Word Immediate
			else if(str[0] =="clgt") {outFile << "01011000000"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // clgt - Compare Logical Greater Than word
			else if(str[0] =="clgti") {outFile << "01011100"<<DecToBin(str[3], 10)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // clgti - Compare Logical Greater Than word Immediate
			else if(str[0] =="clgth") {outFile << "01011001000"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // clght - Compare Logical Greater Than half word
			else if(str[0] =="clgthi") {outFile << "01011101"<<DecToBin(str[3], 10)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  //  clghti - Compare Logical Greater Than halfword Immediate	
			else if(str[0] =="cg") {outFile << "00011000010"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // cg - 	CARRY_GENERATE
			else if(str[0] =="addx") {outFile << "11010000000"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // addx - Add Extended
			else if(str[0] =="bg") {outFile << "00001000010"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // bg - 	BORROW_GENERATE
			else if(str[0] =="sfx") {outFile << "01101000001"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // sfx - Subtract from Extended
			else if(str[0] =="nop") {outFile << "01000000001"<<DecToBin(str_null, 7)<<DecToBin(str_null, 7)<<DecToBin(str_null, 7)<<endl;}  // nop - No Operation even(Execute)
			else if(str[0] =="lnop") {outFile << "00000000001"<<DecToBin(str_null, 7)<<DecToBin(str_null, 7)<<DecToBin(str_null, 7)<<endl;}  //Inop - No Operation odd(Execute)
			else if(str[0] =="stop") {outFile << "00000000000"<<DecToBin(str_null, 7)<<DecToBin(str_null, 7)<<DecToBin(str_null, 7)<<endl;} //stop	
			else if(str[0] =="lqa") {outFile << "001100001"<<DecToBin(str[2], 16)<<DecToBin(str[1], 7)<<endl;}  // lqa - Load Quadword (a-form)
			else if(str[0] =="lqd") {outFile << "00110100"<<DecToBin(str[2], 10)<<DecToBin(str[3], 7)<<DecToBin(str[1], 7)<<endl;}  // lqd - Load Quadword (D-form)
			else if(str[0] =="stqa") {outFile << "001000001"<<DecToBin(str[2], 16)<<DecToBin(str[1], 7)<<endl;}  // stqa - Store Quadword (a-form)
			else if(str[0] =="stqd") {outFile << "00100100"<<DecToBin(str[2], 10)<<DecToBin(str[3], 7)<<DecToBin(str[1], 7)<<endl;}  //stqd - Store Quadword (D-form)
			else if(str[0] =="ilh") {outFile << "010000011"<<DecToBin(str[2], 16)<<DecToBin(str[1], 7)<<endl;}  // ilh - Immediate Load Halfword   
			else if(str[0] =="il") {outFile << "010000001"<<DecToBin(str[2], 16)<<DecToBin(str[1], 7)<<endl;}  //  il - Immediate Load Word
			else if(str[0] =="ila") {outFile << "0100001"<<DecToBin(str[2], 18)<<DecToBin(str[1], 7)<<endl;}  // ila - Immediate Load Address
			else if(str[0] =="gb") {outFile << "00110110000"<<DecToBin(str_null, 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // gb - GATHER_BITS_FROM_WORDS
			else if(str[0] =="gbh") {outFile << "00110110001"<<DecToBin(str_null, 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  //  gbh - GATHER_BITS_FROM_halfWORDS
			else if(str[0] =="shufb") {outFile << "1011"<<DecToBin(str[1], 7)<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[4], 7)<<endl;}  //  shufb -SHUFFLE_BYTES
			else if(str[0] =="shlqbii") {outFile << "00111111011"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  //  Shift Left Quadword by bits Immediate
			else if(str[0] =="shlqbi") {outFile << "00111011011"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // shlqbi - Shift Left Quadword by bits 
			else if(str[0] =="shlqby") {outFile << "00111011111"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  //  shlqby - Shift Left Quadword by Bytes
			else if(str[0] =="shlqbyi") {outFile << "00111111111"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // shlqbyi - Shift Left Quadword by Bytes Immediate
			else if(str[0] =="rotqby") {outFile << "00111011100"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // rotqby - Rotate Quadword by Bytes
			else if(str[0] =="rotqbyi") {outFile << "00111111100"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // rotqbyi - Rotate Quadword by Bytes Immediate
			else if(str[0] =="br") {outFile << "001100100"<<DecToBin(str[1], 16)<<DecToBin(str_null, 7)<<endl;}  //br - Branch Relative
			else if(str[0] =="bra") {outFile << "001100000"<<DecToBin(str[1], 16)<<DecToBin(str_null, 7)<<endl;}  // bra - Branch Absolute
			else if(str[0] =="brnz") {outFile << "001000010"<<DecToBin(str[2], 16)<<DecToBin(str[1], 7)<<endl;}  //  brnz - Branch if Not Zero Word
			else if(str[0] =="brz") {outFile << "001000000"<<DecToBin(str[2], 16)<<DecToBin(str[1], 7)<<endl;}  //  brz - Branch if Zero Word
			else if(str[0] =="brhnz") {outFile << "001000110"<<DecToBin(str[2], 16)<<DecToBin(str[1], 7)<<endl;}  //  brhnz - Branch if Not Zero halfWord
			else if(str[0] =="brhz") {outFile << "001000100"<<DecToBin(str[2], 16)<<DecToBin(str[1], 7)<<endl;}  // brhz - Branch if halfZero Word
			else {cout<<str[0]<<" Instruction not Found"<<endl;}}
			//printf("Data is %s\n",token);}
			
			/*else if(i==1)
			{
				//printf("data is %s\n",temp);
				if(temp =="nop") {outFile << "01000000001"<<DecToBin(str_null, 7)<<DecToBin(str_null, 7)<<DecToBin(str_null, 7)<<endl;}  // nop - No Operation even(Execute)
				else if(temp =="lnop") {outFile << "00000000001"<<DecToBin(str_null, 7)<<DecToBin(str_null, 7)<<DecToBin(str_null, 7)<<endl;}  //Inop - No Operation odd(Execute)
				else if(temp =="stop") {outFile << "00000000000"<<DecToBin(str_null, 7)<<DecToBin(str_null, 7)<<DecToBin(str_null, 7)<<endl;printf("stop\n");} // stop
				else {cout<<temp<<" Instruction not Found Single"<<endl;}
			}
			else if(i==0)
			{
				printf("Empty line\n");
			}*/
	}
    outFile.close();
}


//Decimal to Binary
char* DecToBin(string nums, unsigned bit)
{
    int num;
    istringstream (nums) >> num;
    char *binStr = new char (bit + 1);
    int len = bit;

    binStr[bit] = '\0';
    while (bit--)   binStr[bit] = '0';

    if (num == 0)
        return binStr;

    int r;
    while (num && len)
    {
        r = num % 2;
        binStr[--len] = r + '0';
        num /= 2;
    }

    return binStr;
}