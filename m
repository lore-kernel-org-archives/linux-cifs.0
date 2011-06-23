From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: CIFS VFS errors
Date: Thu, 23 Jun 2011 13:37:59 -0400
Message-ID: <20110623133759.2c3f4aab@barsoom.rdu.redhat.com>
References: <4BEC36376CA24EBFAA83C16B955BD9CC@dynamicsourcemfg.local>
	<20110608164415.5b8cbf4b@tlielax.poochiereds.net>
	<7A5FF1B06368450BAE39549CE3C621CF@dynamicsourcemfg.local>
	<20110622163251.16499f4b@tlielax.poochiereds.net>
	<AC93F84448C9430AB4B791EE591F2F97@dynamicsourcemfg.local>
	<6753F891F47C4E9CBDFB66A63A8E1367@dynamicsourcemfg.local>
	<BANLkTi=T+=yaQ7MH7g+gmqjFgP2HX4iqJg@mail.gmail.com>
	<BCB6EBAD1FD74D7B91FBD8B0FA614384@dynamicsourcemfg.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "Shane McColman" <smccolman-WkVietXGWdS4IGBGpn4MSVaTQe2KTcn/@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BCB6EBAD1FD74D7B91FBD8B0FA614384-WkVietXGWdS4IGBGpn4MSbjjLBE8jN/0@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 23 Jun 2011 09:31:04 -0600
"Shane McColman" <smccolman-WkVietXGWdS4IGBGpn4MSVaTQe2KTcn/@public.gmane.org> wrote:

>=20
> -----Original Message-----
> From: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> [mailto:linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Shirish Pargao=
nkar
> Sent: Thursday, June 23, 2011 8:43 AM
> To: Shane McColman
> Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: CIFS VFS errors
>=20
> On Thu, Jun 23, 2011 at 9:09 AM, Shane McColman
> <smccolman-WkVietXGWdS4IGBGpn4MSVaTQe2KTcn/@public.gmane.org> wrote:
> > Adding wsize to fstab did not work. =A0I restarted things at 4:15 y=
esterday
> > and in less than hour I was back to the same place.
> >
> >
> > Jun 22 16:15:14 fujimoto kernel: [629641.354375] CIFS VFS: Unexpect=
ed
> lookup
> > error -112
> > Jun 22 16:15:14 fujimoto kernel: [629641.354383] CIFS VFS: Unexpect=
ed
> lookup
> > error -112
> > Jun 22 17:08:42 fujimoto kernel: [632843.214260] CIFS VFS: Autodisa=
bling
> the
> > use of server inode numbers on \\d7gsjxb1\AOI_1 (F). This server do=
esn't
> > seem to support them properly. Hardlinks will not be recognized on =
this
> > mount. Consider mounting with the "noserverino" option to silence t=
his
> > message.
> > Jun 22 17:18:11 fujimoto kernel: [633411.476667] CIFS VFS: Send err=
or in
> > read =3D -11
> > Jun 22 17:21:11 fujimoto kernel: [633590.919038] CIFS VFS: Send err=
or in
> > read =3D -11
> > Jun 22 17:23:11 fujimoto kernel: [633710.706852] CIFS VFS: Send err=
or in
> > read =3D -11
> > Jun 22 17:25:11 fujimoto kernel: [633830.436301] CIFS VFS: Send err=
or in
> > read =3D -11
> > Jun 22 17:27:41 fujimoto kernel: [633980.129508] CIFS VFS: Send err=
or in
> > read =3D -11
> > Jun 22 17:28:11 fujimoto kernel: [634010.077463] CIFS VFS: Send err=
or in
> > read =3D -11
> > Jun 22 17:30:11 fujimoto kernel: [634129.838218] CIFS VFS: Send err=
or in
> > read =3D -11
> > Jun 22 17:41:10 fujimoto kernel: [634787.992075] CIFS VFS: Send err=
or in
> > read =3D -11
> >
> > When I came in this morning I did an ls on the directory to check i=
t and
> it
> > has been 15 minutes and I'm still waiting.
> >
> >
> > Shane McColman PEng.
> > Quality Assurance Engineer
> > Dynamic Source Manufacturing Inc.
> > Calgary AB, Canada
> >
> > -----Original Message-----
> > From: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > [mailto:linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Shane McColm=
an
> > Sent: Wednesday, June 22, 2011 4:40 PM
> > To: 'Jeff Layton'
> > Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Subject: RE: CIFS VFS errors
> >
> > I've restarted things and remounted the drive adding wsize to fstab
> >
> > //d7gsjxb1/AOI_1\040(F)/AOI\040Data =A0 =A0 /mnt/AOIData =A0 =A0cif=
s
> > rw,_netdev,guest,uid=3D1000,gid=3D100,wsize=3D16384 =A0 0 0
> >
> > Should have some answers by Monday if not sooner.
> >
> > Shane McColman PEng.
> > Quality Assurance Engineer
> > Dynamic Source Manufacturing Inc.
> > Calgary AB, Canada
> >
> > -----Original Message-----
> > From: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > [mailto:linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Jeff Layton
> > Sent: Wednesday, June 22, 2011 2:33 PM
> > To: Shane McColman
> > Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Subject: Re: CIFS VFS errors
> >
> > On Wed, 22 Jun 2011 14:12:23 -0600
> > "Shane McColman" <smccolman-WkVietXGWdS4IGBGpn4MSVaTQe2KTcn/@public.gmane.org> wrote:
> >
> >> Over the past two days the number of error messages stayed the sam=
e but
> > now
> >> I'm getting the same problems as reported in
> >>
> >> Bug 36952 - =A0[2.6.39] CIFS write failures where 2.6.38 works
> >>
> >> I had to restart my software this morning, but I'm pretty sure I s=
hould
> be
> >> back to the same spot by Monday (if not sooner). =A0I can turn on =
debug
> >> logging (as suggested by Jeff in reply to Helge's email) if somebo=
dy is
> >> interested. =A0Just let me know. =A0I really need to get this fixe=
d, so just
> > let
> >> me know what I can do to help.
> >>
> >
> > I suspect that the issue is with signed connections. Are you using
> > signed authentication? The patch that I posted earlier today should=
 fix
> > this in mainline if so.
> >
> > We'll need to do something different for 2.6.39 though. A possible
> > workaround in the meantime is to set the wsize to something smaller=
, eg
> > wsize=3D16384. Could you try that and let me know if it makes the p=
roblem
> > go away?
> >
> > --
> > Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cif=
s" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cif=
s" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cif=
s" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
> >
>=20
> > what does command   modinfo cifs   return version of cifs as?
>=20
> root@fujimoto:/home/mccolman# modinfo cifs
> filename:       /lib/modules/2.6.39.1-shane/kernel/fs/cifs/cifs.ko
> version:        1.71
> description:    VFS to access servers complying with the SNIA CIFS
> Specification e.g. Samba and Windows
> license:        GPL
> author:         Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> srcversion:     4599E87EC924E5A8F258B49
> depends:       =20
> vermagic:       2.6.39.1-shane SMP mod_unload modversions=20
> parm:           CIFSMaxBufSize:Network buffer size (not including hea=
der).
> Default: 16384 Range: 8192 to 130048 (int)
> parm:           cifs_min_rcv:Network buffers in pool. Default: 4 Rang=
e: 1 to
> 64 (int)
> parm:           cifs_min_small:Small network buffers in pool. Default=
: 30
> Range: 2 to 256 (int)
> parm:           cifs_max_pending:Simultaneous requests to server. Def=
ault:
> 50 Range: 2 to 256 (int)
> parm:           echo_retries:Number of echo attempts before giving up=
 and
> reconnecting server. Default: 5. 0 means never reconnect. (ushort)
>=20
>=20
> >I think Jeff's patches are in 1.69 onwards versions of cifs.
> >Looks like the requests are timing out which should not be the case.
> >Do you see reconnects in /proc/fs/cifs/Stats?
>=20
> I don't have such a file
>=20
> root@fujimoto:/home/mccolman# ls /proc/fs/cifs/
> cifsFYI  DebugData  LinuxExtensionsEnabled  LookupCacheEnabled
> MultiuserMount  OplockEnabled  SecurityFlags  traceSMB
>=20
> Below is a quick wireshark trace I did this morning.  I've only inclu=
ded
> communication with the machine in question and dropped the rest.
>=20
> No.,Time,Source,Destination,Protocol,Info
> 811,2.702507,192.168.0.177,192.168.0.118,TCP,"microsoft-ds > 47072 [R=
ST,
> ACK] Seq=3D1 Ack=3D1 Win=3D0 Len=3D0"
> 812,2.702595,192.168.0.118,192.168.0.177,TCP,47130 > microsoft-ds [SY=
N]
> Seq=3D0 Win=3D14600 Len=3D0 MSS=3D1460 TSV=3D172619118 TSER=3D0 WS=3D=
7
> 813,2.702744,192.168.0.177,192.168.0.118,TCP,"microsoft-ds > 47130 [S=
YN,
> ACK] Seq=3D0 Ack=3D1 Win=3D65535 Len=3D0 MSS=3D1460 WS=3D0 TSV=3D0 TS=
ER=3D0"
> 814,2.702756,192.168.0.118,192.168.0.177,TCP,47130 > microsoft-ds [AC=
K]
> Seq=3D1 Ack=3D1 Win=3D14720 Len=3D0 TSV=3D172619118 TSER=3D0
> 815,2.702809,192.168.0.118,192.168.0.177,SMB,Negotiate Protocol Reque=
st
> 816,2.703111,192.168.0.177,192.168.0.118,SMB,Negotiate Protocol Respo=
nse
> 817,2.703128,192.168.0.118,192.168.0.177,TCP,47130 > microsoft-ds [AC=
K]
> Seq=3D83 Ack=3D120 Win=3D14720 Len=3D0 TSV=3D172619118 TSER=3D2627148=
8
> 818,2.703198,192.168.0.118,192.168.0.177,SMB,"Session Setup AndX Requ=
est,
> User: anonymous"
> 819,2.704252,192.168.0.177,192.168.0.118,SMB,Session Setup AndX Respo=
nse
> 820,2.704344,192.168.0.118,192.168.0.177,SMB,"Tree Connect AndX Reque=
st,
> Path: \\d7gsjxb1\AOI_1 (F)"
> 821,2.704572,192.168.0.177,192.168.0.118,SMB,Tree Connect AndX Respon=
se
> 822,2.704595,192.168.0.118,192.168.0.177,SMB,"Trans2 Request,
> QUERY_PATH_INFO, Query File All Info, Path: \AOI
> Data\NewDL14_Job#10857R_A_1106.txt"
> 823,2.704627,192.168.0.118,192.168.0.177,SMB,"Trans2 Request,
> QUERY_PATH_INFO, Query File All Info, Path: \AOI
> Data\nspecdl18_Job#10839_A_1106.txt"
> 824,2.704659,192.168.0.118,192.168.0.177,SMB,"Trans2 Request,
> QUERY_PATH_INFO, Query File All Info, Path: \AOI
> Data\NewDL14_Job#10686R_A_1106.txt"
> 825,2.704715,192.168.0.118,192.168.0.177,SMB,"Trans2 Request,
> QUERY_PATH_INFO, Query File All Info, Path: \AOI Data\NewDL14_
> Job#GoldenR_A_1106.txt"
> 826,2.704742,192.168.0.118,192.168.0.177,SMB,"Trans2 Request,
> QUERY_PATH_INFO, Query File All Info, Path: \AOI Data\NewDL14_
> Job#10816R_A_1106.txt"
> 827,2.70479,192.168.0.118,192.168.0.177,SMB,"Trans2 Request,
> QUERY_PATH_INFO, Query File All Info, Path: \AOI Data\nspec AOI
> LINE1_Job#I2982_A_1106.txt"
> 828,2.704815,192.168.0.118,192.168.0.177,SMB,"Trans2 Request,
> QUERY_PATH_INFO, Query File All Info, Path: \AOI
> Data\NspecDL14Line2_Job#i2978_A_1106.txt"
> 829,2.704943,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 830,2.704959,192.168.0.118,192.168.0.177,SMB,"Trans2 Request,
> QUERY_PATH_INFO, Query File All Info, Path: \AOI
> Data\NspecDL14Line2_Job#I2943_B_1106.txt"
> 831,2.70514,192.168.0.177,192.168.0.118,TCP,microsoft-ds > 47130 [ACK=
]
> Seq=3D573 Ack=3D2045 Win=3D64981 Len=3D0 TSV=3D26271488 TSER=3D172619=
119
> 832,2.705219,192.168.0.177,192.168.0.118,TCP,microsoft-ds > 47130 [AC=
K]
> Seq=3D573 Ack=3D3493 Win=3D63533 Len=3D0 TSV=3D26271488 TSER=3D172619=
119
> 833,2.705283,192.168.0.177,192.168.0.118,TCP,[TCP Window Update]
> microsoft-ds > 47130 [ACK] Seq=3D573 Ack=3D3493 Win=3D65079 Len=3D0 T=
SV=3D26271488
> TSER=3D172619119
> 834,2.705353,192.168.0.177,192.168.0.118,TCP,microsoft-ds > 47130 [AC=
K]
> Seq=3D573 Ack=3D4941 Win=3D63631 Len=3D0 TSV=3D26271488 TSER=3D172619=
119
> 835,2.705427,192.168.0.177,192.168.0.118,TCP,[TCP Window Update]
> microsoft-ds > 47130 [ACK] Seq=3D573 Ack=3D4941 Win=3D65183 Len=3D0 T=
SV=3D26271488
> TSER=3D172619119
> 836,2.705475,192.168.0.177,192.168.0.118,TCP,microsoft-ds > 47130 [AC=
K]
> Seq=3D573 Ack=3D6389 Win=3D63735 Len=3D0 TSV=3D26271488 TSER=3D172619=
119
> 837,2.705552,192.168.0.177,192.168.0.118,TCP,[TCP Window Update]
> microsoft-ds > 47130 [ACK] Seq=3D573 Ack=3D6389 Win=3D65197 Len=3D0 T=
SV=3D26271488
> TSER=3D172619119
> 838,2.705599,192.168.0.177,192.168.0.118,TCP,microsoft-ds > 47130 [AC=
K]
> Seq=3D573 Ack=3D7837 Win=3D63749 Len=3D0 TSV=3D26271488 TSER=3D172619=
119
> 839,2.705691,192.168.0.177,192.168.0.118,TCP,[TCP Window Update]
> microsoft-ds > 47130 [ACK] Seq=3D573 Ack=3D7837 Win=3D65253 Len=3D0 T=
SV=3D26271488
> TSER=3D172619119
> 840,2.705756,192.168.0.177,192.168.0.118,TCP,microsoft-ds > 47130 [AC=
K]
> Seq=3D573 Ack=3D9285 Win=3D63805 Len=3D0 TSV=3D26271488 TSER=3D172619=
119
> 841,2.705937,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 842,2.705949,192.168.0.118,192.168.0.177,SMB,"Trans2 Request,
> QUERY_PATH_INFO, Query File All Info, Path: \AOI
> Data\NewDL14_Job#10773R_B_1106.txt"
> 843,2.706021,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 844,2.706069,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 845,2.706083,192.168.0.118,192.168.0.177,TCP,47130 > microsoft-ds [AC=
K]
> Seq=3D10277 Ack=3D1337 Win=3D19968 Len=3D0 TSV=3D172619119 TSER=3D262=
71488
> 846,2.706207,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 847,2.70622,192.168.0.118,192.168.0.177,SMB,"Trans2 Request,
> QUERY_PATH_INFO, Query File All Info, Path: \AOI
> Data\NewDL14_Job#10872R_A_1106.txt"
> 848,2.706341,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 849,2.706351,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 850,2.706378,192.168.0.118,192.168.0.177,TCP,47130 > microsoft-ds [AC=
K]
> Seq=3D10851 Ack=3D2091 Win=3D23296 Len=3D0 TSV=3D172619119 TSER=3D262=
71488
> 851,2.706406,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 852,2.706448,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 853,2.706459,192.168.0.118,192.168.0.177,TCP,47130 > microsoft-ds [AC=
K]
> Seq=3D10851 Ack=3D2607 Win=3D25344 Len=3D0 TSV=3D172619119 TSER=3D262=
71488
> 854,2.706572,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 855,2.706587,192.168.0.118,192.168.0.177,SMB,"Trans2 Request,
> QUERY_PATH_INFO, Query File All Info, Path: \AOI Data\NewDL14_
> Job#10773_A_1106.txt"
> 856,2.70669,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 857,2.706784,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 858,2.706797,192.168.0.118,192.168.0.177,TCP,47130 > microsoft-ds [AC=
K]
> Seq=3D11825 Ack=3D3353 Win=3D28544 Len=3D0 TSV=3D172619119 TSER=3D262=
71488
> 859,2.706876,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 860,2.706982,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 861,2.706995,192.168.0.118,192.168.0.177,TCP,47130 > microsoft-ds [AC=
K]
> Seq=3D11825 Ack=3D3847 Win=3D30720 Len=3D0 TSV=3D172619119 TSER=3D262=
71488
> 862,2.707097,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 863,2.707126,192.168.0.118,192.168.0.177,SMB,"Trans2 Request,
> QUERY_PATH_INFO, Query File All Info, Path: \AOI Data\NewDL14_
> Job#GoldenR_A_1106.txt"
> 864,2.707209,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 865,2.707309,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 866,2.707322,192.168.0.118,192.168.0.177,TCP,47130 > microsoft-ds [AC=
K]
> Seq=3D12787 Ack=3D4599 Win=3D33920 Len=3D0 TSV=3D172619119 TSER=3D262=
71488
> 867,2.7074,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 868,2.707512,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 869,2.707524,192.168.0.118,192.168.0.177,TCP,47130 > microsoft-ds [AC=
K]
> Seq=3D12787 Ack=3D5113 Win=3D36096 Len=3D0 TSV=3D172619119 TSER=3D262=
71488
> 870,2.70761,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 871,2.707624,192.168.0.118,192.168.0.177,SMB,"Trans2 Request,
> QUERY_PATH_INFO, Query File All Info, Path: \AOI
> Data\NewDL14_Job#GoldenR_A_1106.txt"
> 872,2.707721,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 873,2.707817,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 874,2.707831,192.168.0.118,192.168.0.177,TCP,47130 > microsoft-ds [AC=
K]
> Seq=3D13361 Ack=3D5861 Win=3D39296 Len=3D0 TSV=3D172619120 TSER=3D262=
71488
> 875,2.707917,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 876,2.708046,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 877,2.708059,192.168.0.118,192.168.0.177,TCP,47130 > microsoft-ds [AC=
K]
> Seq=3D13361 Ack=3D6365 Win=3D41472 Len=3D0 TSV=3D172619120 TSER=3D262=
71488
> 878,2.708139,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 879,2.708252,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 880,2.708264,192.168.0.118,192.168.0.177,TCP,47130 > microsoft-ds [AC=
K]
> Seq=3D13361 Ack=3D6871 Win=3D43648 Len=3D0 TSV=3D172619120 TSER=3D262=
71488
> 881,2.708353,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 882,2.70846,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 883,2.708472,192.168.0.118,192.168.0.177,TCP,47130 > microsoft-ds [AC=
K]
> Seq=3D13361 Ack=3D7393 Win=3D45696 Len=3D0 TSV=3D172619120 TSER=3D262=
71488
> 884,2.708554,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 885,2.708665,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 886,2.708676,192.168.0.118,192.168.0.177,TCP,47130 > microsoft-ds [AC=
K]
> Seq=3D13361 Ack=3D7895 Win=3D47872 Len=3D0 TSV=3D172619120 TSER=3D262=
71488
> 887,2.708762,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 888,2.708871,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 889,2.708898,192.168.0.118,192.168.0.177,TCP,47130 > microsoft-ds [AC=
K]
> Seq=3D13361 Ack=3D8409 Win=3D50048 Len=3D0 TSV=3D172619120 TSER=3D262=
71488
> 890,2.70897,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 891,2.709078,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 892,2.709092,192.168.0.118,192.168.0.177,TCP,47130 > microsoft-ds [AC=
K]
> Seq=3D13361 Ack=3D8925 Win=3D52224 Len=3D0 TSV=3D172619120 TSER=3D262=
71488
> 893,2.70917,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 894,2.709286,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 895,2.709297,192.168.0.118,192.168.0.177,TCP,47130 > microsoft-ds [AC=
K]
> Seq=3D13361 Ack=3D9427 Win=3D54272 Len=3D0 TSV=3D172619120 TSER=3D262=
71488
> 896,2.70938,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 897,2.709489,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 898,2.709502,192.168.0.118,192.168.0.177,TCP,47130 > microsoft-ds [AC=
K]
> Seq=3D13361 Ack=3D9923 Win=3D56448 Len=3D0 TSV=3D172619120 TSER=3D262=
71488
> 899,2.709586,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 900,2.709697,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 901,2.70971,192.168.0.118,192.168.0.177,TCP,47130 > microsoft-ds [ACK=
]
> Seq=3D13361 Ack=3D10423 Win=3D58624 Len=3D0 TSV=3D172619120 TSER=3D26=
271488
> 902,2.709784,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 903,2.747585,192.168.0.118,192.168.0.177,TCP,47130 > microsoft-ds [AC=
K]
> Seq=3D13361 Ack=3D10649 Win=3D59648 Len=3D0 TSV=3D172619130 TSER=3D26=
271488
> 3910,12.706084,192.168.0.118,192.168.0.177,SMB,"Trans2 Request,
> QUERY_PATH_INFO, Query File All Info, Path: \AOI
> Data\NewDL14_Job#10679R_A_1106.txt"
> 3911,12.707219,192.168.0.118,192.168.0.177,SMB,"Trans2 Request,
> QUERY_PATH_INFO, Query File All Info, Path: \AOI
> Data\NewDL14_Job#10686R_A_1106.txt"
> 3912,12.707686,192.168.0.177,192.168.0.118,TCP,microsoft-ds > 47130 [=
ACK]
> Seq=3D10649 Ack=3D14999 Win=3D58091 Len=3D0 TSV=3D26271588 TSER=3D172=
621619
> 3913,12.711617,192.168.0.118,192.168.0.177,SMB,"Trans2 Request,
> QUERY_PATH_INFO, Query File All Info, Path: \AOI
> Data\nspecdl18_Job#10611R_A_1106.txt"
> 3914,12.711705,192.168.0.118,192.168.0.177,SMB,"Trans2 Request,
> QUERY_PATH_INFO, Query File All Info, Path: \AOI Data\nspec AOI LINE1=
_
> Job#i2960_A_1106.txt"
> 3915,12.712159,192.168.0.177,192.168.0.118,TCP,microsoft-ds > 47130 [=
ACK]
> Seq=3D10649 Ack=3D17111 Win=3D55979 Len=3D0 TSV=3D26271588 TSER=3D172=
621621
> 3916,12.712171,192.168.0.118,192.168.0.177,SMB,"Trans2 Request,
> QUERY_PATH_INFO, Query File All Info, Path: \AOI
> Data\NspecDL14Line2_Job#10865R_A_1106.txt"
> 3983,12.905511,192.168.0.177,192.168.0.118,TCP,microsoft-ds > 47130 [=
ACK]
> Seq=3D10649 Ack=3D18011 Win=3D55079 Len=3D0 TSV=3D26271591 TSER=3D172=
621621
> 10027,32.702354,192.168.0.177,192.168.0.118,TCP,"microsoft-ds > 47130=
 [RST,
> ACK] Seq=3D10649 Ack=3D18011 Win=3D0 Len=3D0"
> 10028,32.702439,192.168.0.118,192.168.0.177,TCP,47143 > microsoft-ds =
[SYN]
> Seq=3D0 Win=3D14600 Len=3D0 MSS=3D1460 TSV=3D172626618 TSER=3D0 WS=3D=
7
> 10029,32.702584,192.168.0.177,192.168.0.118,TCP,"microsoft-ds > 47143=
 [SYN,
> ACK] Seq=3D0 Ack=3D1 Win=3D65535 Len=3D0 MSS=3D1460 WS=3D0 TSV=3D0 TS=
ER=3D0"
> 10030,32.702595,192.168.0.118,192.168.0.177,TCP,47143 > microsoft-ds =
[ACK]
> Seq=3D1 Ack=3D1 Win=3D14720 Len=3D0 TSV=3D172626618 TSER=3D0
> 10031,32.702647,192.168.0.118,192.168.0.177,SMB,Negotiate Protocol Re=
quest
> 10032,32.70289,192.168.0.177,192.168.0.118,SMB,Negotiate Protocol Res=
ponse
> 10033,32.702907,192.168.0.118,192.168.0.177,TCP,47143 > microsoft-ds =
[ACK]
> Seq=3D83 Ack=3D120 Win=3D14720 Len=3D0 TSV=3D172626618 TSER=3D2627178=
9
> 10034,32.702975,192.168.0.118,192.168.0.177,SMB,"Session Setup AndX R=
equest,
> User: anonymous"
> 10035,32.704005,192.168.0.177,192.168.0.118,SMB,Session Setup AndX Re=
sponse
> 10036,32.704072,192.168.0.118,192.168.0.177,SMB,"Tree Connect AndX Re=
quest,
> Path: \\d7gsjxb1\AOI_1 (F)"
> 10037,32.704276,192.168.0.177,192.168.0.118,SMB,Tree Connect AndX Res=
ponse
> 10038,32.704302,192.168.0.118,192.168.0.177,SMB,"Trans2 Request,
> QUERY_PATH_INFO, Query File All Info, Path: \AOI
> Data\NewDL14_Job#10910R_A_1106.txt"
> 10039,32.704336,192.168.0.118,192.168.0.177,SMB,"Trans2 Request,
> QUERY_PATH_INFO, Query File All Info, Path: \AOI
> Data\nspecdl18_Job#10796R_A_1106.txt"
> 10040,32.704361,192.168.0.118,192.168.0.177,SMB,"Trans2 Request,
> QUERY_PATH_INFO, Query File All Info, Path: \AOI
> Data\NspecDL14Line2_Job#i2978_A_1106.txt"
> 10041,32.704392,192.168.0.118,192.168.0.177,SMB,"Trans2 Request,
> QUERY_PATH_INFO, Query File All Info, Path: \AOI Data\NewDL14_
> Job#GoldenR_A_1106.txt"
> 10042,32.704417,192.168.0.118,192.168.0.177,SMB,"Trans2 Request,
> QUERY_PATH_INFO, Query File All Info, Path: \AOI
> Data\nspecdl18_Job#10611_B_1106.txt"
> 10043,32.704448,192.168.0.118,192.168.0.177,SMB,"Trans2 Request,
> QUERY_PATH_INFO, Query File All Info, Path: \AOI
> Data\NewDL14_Job#10679R_A_1106.txt"
> 10044,32.704476,192.168.0.118,192.168.0.177,SMB,"Trans2 Request,
> QUERY_PATH_INFO, Query File All Info, Path: \AOI
> Data\NspecDL14Line2_Job#I2976_B_1106.txt"
> 10045,32.704642,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 10046,32.704658,192.168.0.118,192.168.0.177,SMB,"Trans2 Request,
> QUERY_PATH_INFO, Query File All Info, Path: \AOI
> Data\NspecDL14Line2_Job#I2943_B_1106.txt"
> 10047,32.704847,192.168.0.177,192.168.0.118,TCP,microsoft-ds > 47143 =
[ACK]
> Seq=3D565 Ack=3D2037 Win=3D65021 Len=3D0 TSV=3D26271789 TSER=3D172626=
619
> 10048,32.704999,192.168.0.177,192.168.0.118,TCP,microsoft-ds > 47143 =
[ACK]
> Seq=3D565 Ack=3D3485 Win=3D65135 Len=3D0 TSV=3D26271789 TSER=3D172626=
619
> 10049,32.705064,192.168.0.177,192.168.0.118,TCP,microsoft-ds > 47143 =
[ACK]
> Seq=3D565 Ack=3D4933 Win=3D63687 Len=3D0 TSV=3D26271789 TSER=3D172626=
619
> 10050,32.705151,192.168.0.177,192.168.0.118,TCP,[TCP Window Update]
> microsoft-ds > 47143 [ACK] Seq=3D565 Ack=3D4933 Win=3D65229 Len=3D0 T=
SV=3D26271789
> TSER=3D172626619
> 10051,32.7052,192.168.0.177,192.168.0.118,TCP,microsoft-ds > 47143 [A=
CK]
> Seq=3D565 Ack=3D6381 Win=3D63781 Len=3D0 TSV=3D26271789 TSER=3D172626=
619
> 10052,32.705286,192.168.0.177,192.168.0.118,TCP,[TCP Window Update]
> microsoft-ds > 47143 [ACK] Seq=3D565 Ack=3D6381 Win=3D65321 Len=3D0 T=
SV=3D26271789
> TSER=3D172626619
> 10053,32.705429,192.168.0.177,192.168.0.118,TCP,microsoft-ds > 47143 =
[ACK]
> Seq=3D565 Ack=3D9277 Win=3D62425 Len=3D0 TSV=3D26271789 TSER=3D172626=
619
> 10054,32.705458,192.168.0.177,192.168.0.118,TCP,[TCP Window Update]
> microsoft-ds > 47143 [ACK] Seq=3D565 Ack=3D9277 Win=3D63963 Len=3D0 T=
SV=3D26271789
> TSER=3D172626619
> 10055,32.7055,192.168.0.177,192.168.0.118,TCP,microsoft-ds > 47143 [A=
CK]
> Seq=3D565 Ack=3D9679 Win=3D63561 Len=3D0 TSV=3D26271789 TSER=3D172626=
619
> 10056,32.705672,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 10057,32.705738,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 10058,32.705751,192.168.0.118,192.168.0.177,TCP,47143 > microsoft-ds =
[ACK]
> Seq=3D9679 Ack=3D1063 Win=3D18944 Len=3D0 TSV=3D172626619 TSER=3D2627=
1789
> 10059,32.705796,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 10060,32.705901,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 10061,32.705917,192.168.0.118,192.168.0.177,TCP,47143 > microsoft-ds =
[ACK]
> Seq=3D9679 Ack=3D1559 Win=3D21120 Len=3D0 TSV=3D172626619 TSER=3D2627=
1789
> 10062,32.705928,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 10063,32.706008,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 10064,32.706018,192.168.0.118,192.168.0.177,TCP,47143 > microsoft-ds =
[ACK]
> Seq=3D9679 Ack=3D2057 Win=3D23296 Len=3D0 TSV=3D172626619 TSER=3D2627=
1789
> 10065,32.706116,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 10066,32.706149,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 10067,32.706161,192.168.0.118,192.168.0.177,TCP,47143 > microsoft-ds =
[ACK]
> Seq=3D9679 Ack=3D2577 Win=3D25344 Len=3D0 TSV=3D172626619 TSER=3D2627=
1789
> 10068,32.706243,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 10069,32.70636,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 10070,32.706373,192.168.0.118,192.168.0.177,TCP,47143 > microsoft-ds =
[ACK]
> Seq=3D9679 Ack=3D3093 Win=3D27520 Len=3D0 TSV=3D172626619 TSER=3D2627=
1789
> 10071,32.706454,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 10072,32.70657,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 10073,32.706582,192.168.0.118,192.168.0.177,TCP,47143 > microsoft-ds =
[ACK]
> Seq=3D9679 Ack=3D3595 Win=3D29696 Len=3D0 TSV=3D172626619 TSER=3D2627=
1789
> 10074,32.706665,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 10075,32.706778,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 10076,32.706786,192.168.0.118,192.168.0.177,TCP,47143 > microsoft-ds =
[ACK]
> Seq=3D9679 Ack=3D4099 Win=3D31872 Len=3D0 TSV=3D172626619 TSER=3D2627=
1789
> 10077,32.706871,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 10078,32.706875,192.168.0.118,192.168.0.177,SMB,"Trans2 Request,
> QUERY_PATH_INFO, Query File All Info, Path: \AOI Data\NspecDL14Line2_
> Job#10851R_B_1106.txt"
> 10079,32.706899,192.168.0.118,192.168.0.177,SMB,"Trans2 Request,
> QUERY_PATH_INFO, Query File All Info, Path: \AOI
> Data\NewDL14_Job#10872_A_1106.txt"
> 10080,32.706921,192.168.0.118,192.168.0.177,SMB,"Trans2 Request,
> QUERY_PATH_INFO, Query File All Info, Path: \AOI Data\NspecF18 Mac
> mini_Job#i2892R_A_1106.txt"
> 10081,32.706967,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 10082,32.707071,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 10083,32.707181,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 10084,32.707253,192.168.0.118,192.168.0.177,SMB,"Trans2 Request,
> QUERY_PATH_INFO, Query File All Info, Path: \AOI
> Data\NspecDL14Line2_Job#I2942_B_1106.txt"
> 10085,32.707278,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 10086,32.707372,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 10087,32.707379,192.168.0.118,192.168.0.177,TCP,47143 > microsoft-ds =
[ACK]
> Seq=3D12973 Ack=3D5619 Win=3D38272 Len=3D0 TSV=3D172626619 TSER=3D262=
71789
> 10088,32.707476,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 10089,32.707507,192.168.0.177,192.168.0.118,TCP,microsoft-ds > 47143 =
[ACK]
> Seq=3D5863 Ack=3D12973 Win=3D60267 Len=3D0 TSV=3D26271789 TSER=3D1726=
26619
> 10090,32.707516,192.168.0.118,192.168.0.177,SMB,"Trans2 Request,
> QUERY_PATH_INFO, Query File All Info, Path: \AOI
> Data\NewDL14_Job#GoldenR_A_1106.txt"
> 10091,32.708183,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 10092,32.708189,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 10093,32.70819,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 10094,32.708192,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 10095,32.708193,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 10096,32.708195,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 10097,32.708204,192.168.0.118,192.168.0.177,TCP,47143 > microsoft-ds =
[ACK]
> Seq=3D13361 Ack=3D6617 Win=3D42496 Len=3D0 TSV=3D172626620 TSER=3D262=
71789
> 10098,32.708206,192.168.0.118,192.168.0.177,TCP,47143 > microsoft-ds =
[ACK]
> Seq=3D13361 Ack=3D7359 Win=3D45696 Len=3D0 TSV=3D172626620 TSER=3D262=
71789
> 10099,32.70822,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 10100,32.708249,192.168.0.118,192.168.0.177,SMB,"Trans2 Request,
> QUERY_PATH_INFO, Query File All Info, Path: \AOI
> Data\nspecdl18_Job#10679_A_1106.txt"
> 10101,32.708331,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 10102,32.708447,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 10103,32.708459,192.168.0.118,192.168.0.177,TCP,47143 > microsoft-ds =
[ACK]
> Seq=3D13553 Ack=3D8121 Win=3D49024 Len=3D0 TSV=3D172626620 TSER=3D262=
71789
> 10104,32.708544,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 10105,32.708656,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 10106,32.708671,192.168.0.118,192.168.0.177,TCP,47143 > microsoft-ds =
[ACK]
> Seq=3D13553 Ack=3D8623 Win=3D51072 Len=3D0 TSV=3D172626620 TSER=3D262=
71789
> 10107,32.70875,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 10108,32.708863,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 10109,32.708873,192.168.0.118,192.168.0.177,TCP,47143 > microsoft-ds =
[ACK]
> Seq=3D13553 Ack=3D9129 Win=3D53248 Len=3D0 TSV=3D172626620 TSER=3D262=
71789
> 10110,32.708954,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 10111,32.709068,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 10112,32.709099,192.168.0.118,192.168.0.177,TCP,47143 > microsoft-ds =
[ACK]
> Seq=3D13553 Ack=3D9627 Win=3D55424 Len=3D0 TSV=3D172626620 TSER=3D262=
71789
> 10113,32.709163,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 10114,32.709274,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 10115,32.709284,192.168.0.118,192.168.0.177,TCP,47143 > microsoft-ds =
[ACK]
> Seq=3D13553 Ack=3D10127 Win=3D57600 Len=3D0 TSV=3D172626620 TSER=3D26=
271789
> 10116,32.70937,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 10117,32.709483,192.168.0.177,192.168.0.118,SMB,"Trans2 Response,
> QUERY_PATH_INFO"
> 10118,32.709492,192.168.0.118,192.168.0.177,TCP,47143 > microsoft-ds =
[ACK]
> Seq=3D13553 Ack=3D10627 Win=3D59648 Len=3D0 TSV=3D172626620 TSER=3D26=
271789
>=20

Unfortunately, it's near impossible to make any sense of the above
cut-and-paste. What would be most helpful is a binary trace.
Instructions for how to capture that are here:

http://wiki.samba.org/index.php/LinuxCIFS_troubleshooting#Wire_Captures

You may also be able to save a binary version of the capture right out
of wireshark as well.
--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
