#ifndef DOSRTL_BI
#define DOSRTL_BI

Const DosStringBufferCapacity As UByte = 255 - SizeOf(UByte) - SizeOf(UByte)

Type DWORD As ULong
Type WORD As UShort

Type DosStringBuffer
	Capacity As UByte
	Length As UByte
	DosString As ZString * (DosStringBufferCapacity)
End Type

#define MakeDword(low, high) (Cast(ULong, (Cast(UShort, high) And &hFFFF) Shl 16) Or (Cast(UShort, low) And &hFFFF))

Type ProgramSegmentPrefix Field = 1
	Int20hCode(1) As UByte          ' 2, �������� ��� INT 20 ������ �� ��������� � ����� CP/M (��� �������������)
	MemoryTop As WORD               ' 2, �������, ������������� ����� ����� ���������� ��������� ������
	Reserved1 As UByte              ' 1, ���������������
	CallDsp(4) As UByte             ' 5, �������� ��� CALL FAR ��� ������ ������� DOS � ����� CP/M (��� �������������)
	lpTerminateAddress As DWORD     ' 4, ����� ����������� Terminate ���������� ��������� (���������� INT 22)
	lpControlBreal As DWORD         ' 4, ����� ����������� Break ���������� ��������� (���������� INT 23)
	lpCriticalError As DWORD        ' 4, ����� ����������� ����������� ������ ���������� ��������� (���������� INT 24)
	ParentPspSegment As WORD        ' 2, ������� PSP ����������� �������� (��� �������, command.com � ����������)
	FileTable(19) As UByte          ' 20, Job File Table (����������)
	lpEnvironmentHiWord As WORD     ' 2, ������� ���������� �����
	SsSpStackHiWord As DWORD        ' 4, SS:SP �� ����� � ���������� ������ INT 21 (����������)
	MaxOpenFiles As WORD            ' 2, ������������ ���������� �������� ������ (����������)
	FileTBA As DWORD                ' 4, ����� ������ ������� (����������)
	Reserved2(23) As UByte          ' 24, ���������������
	DosDispatchFunction(2) As UByte ' 3, ��� ������ � DOS (������ �������� INT 21 + RETF)
	Reserved3(8) As UByte           ' 9, ���������������
	FileContentBlock1(15) As UByte  ' 16, �������� ������� FCB 1
	FileContentBlock2(19) As UByte  ' 20, �������� ������� FCB (�����������, ���� FCB 1 ������)
	cbCommandLine As UByte          ' 1, ���������� �������� � ��������� ������
	CommandLine As ZString * 127    ' 127, ��������� ������ (����������� &h0D)
End Type

Declare Sub EntryPoint Naked Cdecl()

Declare Sub PrintDosString Cdecl( _
	ByVal pChar As ZString Ptr _
)

Declare Function PrintStringA Cdecl( _
	ByVal p As ZString Ptr, _
	ByVal Length As Short _
)As Short

Declare Sub InputDosString Cdecl( _
	ByVal lpBuffer As DosStringBuffer Ptr _
)

Declare Function IntToStr Cdecl( _
	ByVal n As Integer, _
	ByVal pBuffer As ZString Ptr _
)As Integer

Declare Function StrToInt Cdecl( _
	ByVal pBuffer As ZString Ptr _
)As Integer

#endif
