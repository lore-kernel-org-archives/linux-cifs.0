From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: RE: [PATCH] CIFS: handle guest access errors to Windows shares
Date: Wed, 30 Nov 2016 18:32:07 +0100
Message-ID: <mpswpfkswko.fsf@suse.com>
References: <20161129113646.13360-2-mark.syms@citrix.com> <mpszikis34d.fsf@suse.com> <0d4b27917f3e4a90a19342a7e27b5d9f@AMSPEX02CL02.citrite.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
To: Mark Syms <Mark.Syms-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>,
        "sfrench\@samba.org" <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        "linux-cifs\@vger.kernel.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0d4b27917f3e4a90a19342a7e27b5d9f-ZIyKOb66IhyzM76k4uAzvRgL0UkB//ZR@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--=-=-=
Content-Type: text/plain

Hi Mark,

New setup

  PS> net user guest /activate:no
  PS> mkdir C:\guestshare
  PS> icacls C:\guestshare /grant 'Everyone:(OI)(CI)F'
  PS> new-smbshare -name guestshare -path C:\guestshare -fullaccess Everyone

I've tested v3.10, v4.4, master, master+your patch using default options
(empty or no user "NU") and user=abc (U).

NT_LOGON_FAILURE in session setup: LF
This is what you seem to have in 3.10.

NT_ACCESS_DENIED in tree connect to the share: AD
This is what you get before your infinite loop.

             |   NU       U
-------------------------------- 
3.10         |   LF       LF
4.4          |   LF       LF
master       |   AD       LF
master+patch |   AD       LF

No infinite DFS loop :(
All these issues result in mount failing very fast with permission denied.

I guess it could be from either the Windows version or the share/folder
ACL. A deeper analysis of the packets might reveal more.

In any case I did not notice any issues for on a basic DFS setup with
the patch so I don't think it introduced any regressions, which is
probably all that matters. It still bothers me a little I couldn't hit
the bug.

I've included kernel output w/ debugging output and network capture of
my tests if anyone want to have a look at it. (master+patch = ml-guestfix).

Reviewed-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Tested-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>


--=-=-=
Content-Type: text/plain
Content-Disposition: attachment; filename=v3.10_nouser.out

!! BOOT SCRIPT !!
-------------------

++ echo 10.160.65.202 WS2016
++ modprobe e1000
++ modprobe cifs
++ mount -t debugfs none /sys/kernel/debug
++ echo 'create      cifs.spnego    * * /usr/sbin/cifs.upcall %k'
++ echo 'create      dns_resolver   * * /usr/sbin/cifs.upcall %k'
++ echo 'module cifs +p'
++ echo 'file fs/cifs/* +p'
++ echo 1
++ echo 8
++ echo 1
++ mkdir -p /mnt
++ echo 'echo 1 > /proc/sys/kernel/sysrq && echo o > /proc/sysrq-trigger'
++ chmod a+x /bin/sd
++ mount -t cifs -vvv //WS2016/guestshare /mnt -o ip=10.160.65.202,guest,rw
ip address 10.160.65.202 override specified
mount.cifs kernel mount options: ip=10.160.65.202,unc=\\WS2016\guestshare,user=,pass=********
fs/cifs/cifsfs.c: Devname: //WS2016/guestshare flags: 0
address conversion returned 1 for 10.160.65.202
fs/cifs/connect.c: Anonymous login
fs/cifs/connect.c: file mode: 0x1ed  dir mode: 0x1ed
fs/cifs/connect.c: CIFS VFS: in cifs_mount as Xid: 0 with uid: 0
fs/cifs/connect.c: UNC: \\WS2016\guestshare
fs/cifs/connect.c: Socket created
fs/cifs/connect.c: sndbuf 16384 rcvbuf 87380 rcvtimeo 0x6d6
fs/cifs/connect.c: CIFS VFS: in cifs_get_smb_ses as Xid: 1 with uid: 0
fs/cifs/connect.c: Existing smb sess not found
fs/cifs/cifssmb.c: secFlags 0x81
fs/cifs/cifssmb.c: NTLMSSP only mechanism, enable extended security
fs/cifs/transport.c: For smb_command 114
fs/cifs/transport.c: Sending smb: smb_len=69
fs/cifs/connect.c: Demultiplex PID: 148
fs/cifs/connect.c: RFC1002 header 0xcd
fs/cifs/misc.c: checkSMB Length: 0xd1, smb_buf_length: 0xcd
fs/cifs/transport.c: cifs_sync_mid_result: cmd=114 mid=1 state=4
fs/cifs/cifssmb.c: Dialect: 2
Max buf = 16644
fs/cifs/asn1.c: OID len = 10 oid = 0x1 0x3 0x6 0x1
fs/cifs/asn1.c: OID len = 7 oid = 0x1 0x2 0x348 0xbb92
fs/cifs/asn1.c: OID len = 7 oid = 0x1 0x2 0x348 0x1bb92
fs/cifs/asn1.c: OID len = 8 oid = 0x1 0x2 0x348 0x1bb92
fs/cifs/asn1.c: OID len = 10 oid = 0x1 0x3 0x6 0x1
fs/cifs/cifssmb.c: negprot rc 0
fs/cifs/connect.c: Security Mode: 0xf Capabilities: 0x8001f3fc TimeAdjust: 28800
fs/cifs/sess.c: sess setup type 3
fs/cifs/sess.c: ntlmssp session setup phase 1
fs/cifs/transport.c: For smb_command 115
fs/cifs/transport.c: Sending smb: smb_len=186
fs/cifs/connect.c: RFC1002 header 0x163
fs/cifs/misc.c: checkSMB Length: 0x167, smb_buf_length: 0x163
fs/cifs/transport.c: cifs_sync_mid_result: cmd=115 mid=2 state=4
fs/cifs/netmisc.c: Mapping smb error code 0xc0000016 to POSIX err -5
fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
fs/cifs/sess.c: UID = 8192
fs/cifs/sess.c: bleft 135
fs/cifs/sess.c: serverOS=Windows Server 2016 Standard 14393
fs/cifs/sess.c: serverNOS=Windows Server 2016 Standard 6.3
fs/cifs/sess.c: ssetup freeing small buf ffff880004548540
fs/cifs/sess.c: ntlmssp session setup phase 3
fs/cifs/transport.c: For smb_command 115
fs/cifs/transport.c: Sending smb: smb_len=402
fs/cifs/connect.c: RFC1002 header 0x23
fs/cifs/misc.c: checkSMB Length: 0x27, smb_buf_length: 0x23
fs/cifs/transport.c: cifs_sync_mid_result: cmd=115 mid=3 state=4
Status code returned 0xc000006d NT_STATUS_LOGON_FAILURE
fs/cifs/netmisc.c: Mapping smb error code 0xc000006d to POSIX err -13
fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
fs/cifs/sess.c: ssetup freeing small buf ffff8800045488c0
CIFS VFS: Send error in SessSetup = -13
fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses (xid = 1) rc = -13
fs/cifs/connect.c: CIFS VFS: leaving cifs_mount (xid = 0) rc = -13
CIFS VFS: cifs_mount failed w/return code = -13
mount error(13): Permission denied
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
++ sleep 2
++ sd
SysRq : Power Off
++ set +x


Generating "/run/initramfs/rdsosreport.txt"
You might want to save "/run/initramfs/rdsosreport.txt" to a USB stick or /boot
after mounting them and attach it to a bug report.

To get more debug information in the report,
reboot with "rd.debug" added to the kernel command line.

Dropping to debug shell.

dracut:/# ACPI: Preparing to enter system sleep state S5
Power down.

--=-=-=
Content-Type: application/vnd.tcpdump.pcap
Content-Disposition: attachment; filename=v3.10_nouser.pcap
Content-Transfer-Encoding: base64

Cg0NClQAAABNPCsaAQAAAP//////////BAAtAFRTaGFyayAxLjEyLjEzIChHaXQgUmV2IFVua25v
d24gZnJvbSB1bmtub3duKQAAAAAAAABUAAAAAQAAACAAAAABAAAAAAAEAAkAAQAGAAAAAAAAACAA
AAAGAAAArAAAAAAAAACFQgUAD1/7xYsAAACLAAAAUlQA6PCaABY+Us44CABFAAB91T5AAEAGy1QK
oELeCqBByoHQAb35zQux2viZ5IAYA5G+TgAAAQEICv/+3owfYpyeAAAARf9TTUJyAAAAAAAByAAA
AAAAAAAAAAAAAAAAhAAAAAEAACIAAkxNMS4yWDAwMgACTEFOTUFOMi4xAAJOVCBMTSAwLjEyAACs
AAAABgAAADQBAAAAAAAAhUIFAJhg+8UTAQAAEwEAAAAWPlLOOFJUAOjwmggARQABBRhhQACABkeq
CqBBygqgQt4BvYHQ2viZ5PnNC/qAGCArhD4AAAEBCAofYpyg//7ejAAAAM3/U01CcgAAAACAAcgA
AAAAAAAAAAAAAAAAAIQAAAABABECAA8yAAEABEEAAAAAAQAAAAAA/PMBgPvXEJEYS9IB4AEAiACg
0KhCWhh3TbyiOmkMP5cqYHYGBisGAQUFAqBsMGqgPDA6BgorBgEEAYI3AgIeBgkqhkiC9xIBAgIG
CSqGSIb3EgECAgYKKoZIhvcSAQICAwYKKwYBBAGCNwICCqMqMCigJhskbm90X2RlZmluZWRfaW5f
UkZDNDE3OEBwbGVhc2VfaWdub3JlADQBAAAGAAAAIAEAAAAAAACFQgUArXL7xQABAAAAAQAAUlQA
6PCaABY+Us44CABFAADy1UBAAEAGyt0KoELeCqBByoHQAb35zQv62viatYAYA9SLEAAAAQEICv/+
3o4fYpygAAAAuv9TTUJzAAAAAAAF2AAAQlNSU1BZTAAAAAAAhAAAAAIADP8AAABUQDIAAAAAAAAA
IAAAAAAA3NAAgH8ATlRMTVNTUAABAAAAFQII4AAAAAAAAAAAAAAAAAAAAAAATABpAG4AdQB4ACAA
dgBlAHIAcwBpAG8AbgAgADMALgAxADAALgAwAAAAQwBJAEYAUwAgAFYARgBTACAAQwBsAGkAZQBu
AHQAIABmAG8AcgAgAEwAaQBuAHUAeAAAACABAAAGAAAAzAEAAAAAAACFQgUAqHP7xakBAACpAQAA
ABY+Us44UlQA6PCaCABFAAGbGGJAAIAGRxMKoEHKCqBC3gG9gdDa+Jq1+c0MuIAYICqHqgAAAQEI
Ch9inKX//t6OAAABY/9TTUJzFgAAwIAF2AAAQlNSU1BZTAAAAAAAhAAAIAIABP8AYwEAALAAOAFO
VExNU1NQAAIAAAAIAAgAOAAAABUCieIdvPZTfKYdYgAAAAAAAAAAcABwAEAAAAAKADk4AAAAD1MA
VQBTAEUAAgAIAFMAVQBTAEUAAQAMAFcAUwAyADAAMQA2AAQADgBzAHUAcwBlAC4AZABlAAMAHABX
AFMAMgAwADEANgAuAHMAdQBzAGUALgBkAGUABQAOAHMAdQBzAGUALgBkAGUABwAIAPvXEJEYS9IB
AAAAAABXAGkAbgBkAG8AdwBzACAAUwBlAHIAdgBlAHIAIAAyADAAMQA2ACAAUwB0AGEAbgBkAGEA
cgBkACAAMQA0ADMAOQAzAAAAVwBpAG4AZABvAHcAcwAgAFMAZQByAHYAZQByACAAMgAwADEANgAg
AFMAdABhAG4AZABhAHIAZAAgADYALgAzAAAAAADMAQAABgAAAPgBAAAAAAAAhUIFAJiB+8XYAQAA
2AEAAFJUAOjwmgAWPlLOOAgARQABytVBQABABsoECqBC3gqgQcqB0AG9+c0MuNr4nByAGAQX8DEA
AAEBCAr//t6PH2KcpQAAAZL/U01CcwAAAAAABdgAAEJTUlNQWUwAAAAAAIQAACADAAz/AAAAVEAy
AAAAAAAAAPgAAAAAANzQAIBXAU5UTE1TU1AAAwAAAAAAAABAAAAAnACcAEAAAAAIAAgA3AAAAAAA
AADkAAAAAAAAAOYAAAAQABAA6AAAABUCiOCdvxtBxnhmGF4XBoKGGP5QAQEAAAAAAACvf7SQGEvS
AUOVi+6fUOtZAAAAAAIACABTAFUAUwBFAAEADABXAFMAMgAwADEANgAEAA4AcwB1AHMAZQAuAGQA
ZQADABwAVwBTADIAMAAxADYALgBzAHUAcwBlAC4AZABlAAUADgBzAHUAcwBlAC4AZABlAAcACAD7
1xCRGEvSAQAAAABTAFUAUwBFAAAAAACH/dz7+Etlj7x4d+T9cHIFAEwAaQBuAHUAeAAgAHYAZQBy
AHMAaQBvAG4AIAAzAC4AMQAwAC4AMAAAAEMASQBGAFMAIABWAEYAUwAgAEMAbABpAGUAbgB0ACAA
ZgBvAHIAIABMAGkAbgB1AHgAAAD4AQAABgAAAIwAAAAAAAAAhUIFAFCvAMZpAAAAaQAAAAAWPlLO
OFJUAOjwmggARQAAWxhkQACABkhRCqBBygqgQt4BvYHQ2vicHPnNDk6AGCAp3zAAAAEBCAofYp38
//7ejwAAACP/U01Cc20AAMCABdgAAEJTUlNQWUwAAAAAAIQAACADAAAAAAAAAIwAAAA=
--=-=-=
Content-Type: text/plain
Content-Disposition: attachment; filename=v3.10_user.out

!! BOOT SCRIPT !!
-------------------

++ echo 10.160.65.202 WS2016
++ modprobe e1000
++ modprobe cifs
++ mount -t debugfs none /sys/kernel/debug
++ echo 'create      cifs.spnego    * * /usr/sbin/cifs.upcall %k'
++ echo 'create      dns_resolver   * * /usr/sbin/cifs.upcall %k'
++ echo 'module cifs +p'
++ echo 'file fs/cifs/* +p'
++ echo 1
++ echo 8
++ echo 1
++ mkdir -p /mnt
++ echo 'echo 1 > /proc/sys/kernel/sysrq && echo o > /proc/sysrq-trigger'
++ chmod a+x /bin/sd
++ mount -t cifs -vvv //WS2016/guestshare /mnt -o ip=10.160.65.202,guest,rw,user=abc
ip address 10.160.65.202 override specified
mount.cifs kernel mount options: ip=10.160.65.202,unc=\\WS2016\guestshare,user=abc,pass=********
fs/cifs/cifsfs.c: Devname: //WS2016/guestshare flags: 0
address conversion returned 1 for 10.160.65.202
fs/cifs/connect.c: Username: abc
fs/cifs/connect.c: file mode: 0x1ed  dir mode: 0x1ed
fs/cifs/connect.c: CIFS VFS: in cifs_mount as Xid: 0 with uid: 0
fs/cifs/connect.c: UNC: \\WS2016\guestshare
fs/cifs/connect.c: Socket created
fs/cifs/connect.c: sndbuf 16384 rcvbuf 87380 rcvtimeo 0x6d6
fs/cifs/connect.c: CIFS VFS: in cifs_get_smb_ses as Xid: 1 with uid: 0
fs/cifs/connect.c: Existing smb sess not found
fs/cifs/cifssmb.c: secFlags 0x81
fs/cifs/cifssmb.c: NTLMSSP only mechanism, enable extended security
fs/cifs/transport.c: For smb_command 114
fs/cifs/transport.c: Sending smb: smb_len=69
fs/cifs/connect.c: Demultiplex PID: 148
fs/cifs/connect.c: RFC1002 header 0xcd
fs/cifs/misc.c: checkSMB Length: 0xd1, smb_buf_length: 0xcd
fs/cifs/transport.c: cifs_sync_mid_result: cmd=114 mid=1 state=4
fs/cifs/cifssmb.c: Dialect: 2
Max buf = 16644
fs/cifs/asn1.c: OID len = 10 oid = 0x1 0x3 0x6 0x1
fs/cifs/asn1.c: OID len = 7 oid = 0x1 0x2 0x348 0xbb92
fs/cifs/asn1.c: OID len = 7 oid = 0x1 0x2 0x348 0x1bb92
fs/cifs/asn1.c: OID len = 8 oid = 0x1 0x2 0x348 0x1bb92
fs/cifs/asn1.c: OID len = 10 oid = 0x1 0x3 0x6 0x1
fs/cifs/cifssmb.c: negprot rc 0
fs/cifs/connect.c: Security Mode: 0xf Capabilities: 0x8001f3fc TimeAdjust: 28800
fs/cifs/sess.c: sess setup type 3
fs/cifs/sess.c: ntlmssp session setup phase 1
fs/cifs/transport.c: For smb_command 115
fs/cifs/transport.c: Sending smb: smb_len=186
fs/cifs/connect.c: RFC1002 header 0x163
fs/cifs/misc.c: checkSMB Length: 0x167, smb_buf_length: 0x163
fs/cifs/transport.c: cifs_sync_mid_result: cmd=115 mid=2 state=4
fs/cifs/netmisc.c: Mapping smb error code 0xc0000016 to POSIX err -5
fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
fs/cifs/sess.c: UID = 8192
fs/cifs/sess.c: bleft 135
fs/cifs/sess.c: serverOS=Windows Server 2016 Standard 14393
fs/cifs/sess.c: serverNOS=Windows Server 2016 Standard 6.3
fs/cifs/sess.c: ssetup freeing small buf ffff880004525540
fs/cifs/sess.c: ntlmssp session setup phase 3
fs/cifs/transport.c: For smb_command 115
fs/cifs/transport.c: Sending smb: smb_len=406
fs/cifs/connect.c: RFC1002 header 0x23
fs/cifs/misc.c: checkSMB Length: 0x27, smb_buf_length: 0x23
fs/cifs/transport.c: cifs_sync_mid_result: cmd=115 mid=3 state=4
Status code returned 0xc000006d NT_STATUS_LOGON_FAILURE
fs/cifs/netmisc.c: Mapping smb error code 0xc000006d to POSIX err -13
fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
fs/cifs/sess.c: ssetup freeing small buf ffff8800045258c0
CIFS VFS: Send error in SessSetup = -13
fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses (xid = 1) rc = -13
fs/cifs/connect.c: CIFS VFS: leaving cifs_mount (xid = 0) rc = -13
CIFS VFS: cifs_mount failed w/return code = -13
mount error(13): Permission denied
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
++ sleep 2
++ sd
SysRq : Power Off
++ set +x


Generating "/run/initramfs/rdsosreport.txt"
You might want to save "/run/initramfs/rdsosreport.txt" to a USB stick or /boot
after mounting them and attach it to a bug report.

To get more debug information in the report,
reboot with "rd.debug" added to the kernel command line.

Dropping to debug shell.

dracut:/# ACPI: Preparing to enter system sleep state S5
Power down.

--=-=-=
Content-Type: application/vnd.tcpdump.pcap
Content-Disposition: attachment; filename=v3.10_user.pcap
Content-Transfer-Encoding: base64

Cg0NClQAAABNPCsaAQAAAP//////////BAAtAFRTaGFyayAxLjEyLjEzIChHaXQgUmV2IFVua25v
d24gZnJvbSB1bmtub3duKQAAAAAAAABUAAAAAQAAACAAAAABAAAAAAAEAAkAAQAGAAAAAAAAACAA
AAAGAAAArAAAAAAAAACFQgUABC2RxosAAACLAAAAUlQA6PCaABY+VbjOCABFAAB9OVRAAEAGZ3wK
oEKhCqBByqRsAb01e+fb7k4shoAYA5G3ygAAAQEICv/+3ogfYsL3AAAARf9TTUJyAAAAAAAByAAA
AAAAAAAAAAAAAAAAhAAAAAEAACIAAkxNMS4yWDAwMgACTEFOTUFOMi4xAAJOVCBMTSAwLjEyAACs
AAAABgAAADQBAAAAAAAAhUIFAEQukcYTAQAAEwEAAAAWPlW4zlJUAOjwmggARQABBX3SQACABuJ1
CqBBygqgQqEBvaRs7k4shjV76CSAGAQFz5UAAAEBCAofYsL5//7eiAAAAM3/U01CcgAAAACAAcgA
AAAAAAAAAAAAAAAAAIQAAAABABECAA8yAAEABEEAAAAAAQAAAAAA/PMBgOwc6pYYS9IB4AEAiACg
0KhCWhh3TbyiOmkMP5cqYHYGBisGAQUFAqBsMGqgPDA6BgorBgEEAYI3AgIeBgkqhkiC9xIBAgIG
CSqGSIb3EgECAgYKKoZIhvcSAQICAwYKKwYBBAGCNwICCqMqMCigJhskbm90X2RlZmluZWRfaW5f
UkZDNDE3OEBwbGVhc2VfaWdub3JlADQBAAAGAAAAIAEAAAAAAACFQgUAPj6RxgABAAAAAQAAUlQA
6PCaABY+VbjOCABFAADyOVZAAEAGZwUKoEKhCqBByqRsAb01e+gk7k4tV4AYA9SEjQAAAQEICv/+
3okfYsL5AAAAuv9TTUJzAAAAAAAF2AAAQlNSU1BZTAAAAAAAhAAAAAIADP8AAABUQDIAAAAAAAAA
IAAAAAAA3NAAgH8ATlRMTVNTUAABAAAAFQII4AAAAAAAAAAAAAAAAAAAAAAATABpAG4AdQB4ACAA
dgBlAHIAcwBpAG8AbgAgADMALgAxADAALgAwAAAAQwBJAEYAUwAgAFYARgBTACAAQwBsAGkAZQBu
AHQAIABmAG8AcgAgAEwAaQBuAHUAeAAAACABAAAGAAAAzAEAAAAAAACFQgUA6T6RxqkBAACpAQAA
ABY+VbjOUlQA6PCaCABFAAGbfdNAAIAG4d4KoEHKCqBCoQG9pGzuTi1XNXvo4oAYBAQj5wAAAQEI
Ch9iwv7//t6JAAABY/9TTUJzFgAAwIAF2AAAQlNSU1BZTAAAAAAAhAAAIAIABP8AYwEAALAAOAFO
VExNU1NQAAIAAAAIAAgAOAAAABUCieJ7nGkstrbsxgAAAAAAAAAAcABwAEAAAAAKADk4AAAAD1MA
VQBTAEUAAgAIAFMAVQBTAEUAAQAMAFcAUwAyADAAMQA2AAQADgBzAHUAcwBlAC4AZABlAAMAHABX
AFMAMgAwADEANgAuAHMAdQBzAGUALgBkAGUABQAOAHMAdQBzAGUALgBkAGUABwAIAOwc6pYYS9IB
AAAAAMJXAGkAbgBkAG8AdwBzACAAUwBlAHIAdgBlAHIAIAAyADAAMQA2ACAAUwB0AGEAbgBkAGEA
cgBkACAAMQA0ADMAOQAzAAAAVwBpAG4AZABvAHcAcwAgAFMAZQByAHYAZQByACAAMgAwADEANgAg
AFMAdABhAG4AZABhAHIAZAAgADYALgAzAAAAAADMAQAABgAAAPwBAAAAAAAAhUIFAKxMkcbcAQAA
3AEAAFJUAOjwmgAWPlW4zggARQABzjlXQABABmYoCqBCoQqgQcqkbAG9NXvo4u5OLr6AGAQXkYIA
AAEBCAr//t6KH2LC/gAAAZb/U01CcwAAAAAABdgAAEJTUlNQWUwAAAAAAIQAACADAAz/AAAAVEAy
AAAAAAAAAPwAAAAAANzQAIBbAU5UTE1TU1AAAwAAAAAAAABAAAAAnACcAEAAAAAIAAgA3AAAAAYA
BgDkAAAAAAAAAOoAAAAQABAA7AAAABUCiOA7bJk4u05i4p6nNC8GUD3GAQEAAAAAAADbvA+WGEvS
AUNGlv3IWSDTAAAAAAIACABTAFUAUwBFAAEADABXAFMAMgAwADEANgAEAA4AcwB1AHMAZQAuAGQA
ZQADABwAVwBTADIAMAAxADYALgBzAHUAcwBlAC4AZABlAAUADgBzAHUAcwBlAC4AZABlAAcACADs
HOqWGEvSAQAAAABTAFUAUwBFAGEAYgBjAAAAfgGdSA+McBNBDaCg2xD7WABMAGkAbgB1AHgAIAB2
AGUAcgBzAGkAbwBuACAAMwAuADEAMAAuADAAAABDAEkARgBTACAAVgBGAFMAIABDAGwAaQBlAG4A
dAAgAGYAbwByACAATABpAG4AdQB4AAAA/AEAAAYAAACMAAAAAAAAAIVCBQDiTpHGaQAAAGkAAAAA
Fj5VuM5SVADo8JoIAEUAAFt91EAAgAbjHQqgQcoKoEKhAb2kbO5OLr41e+p8gBgEA/YiAAABAQgK
H2LDAv/+3ooAAAAj/1NNQnNtAADAgAXYAABCU1JTUFlMAAAAAACEAAAgAwAAAAAAAACMAAAA
--=-=-=
Content-Type: text/plain
Content-Disposition: attachment; filename=v4.4_nouser.out

!! BOOT SCRIPT !!
-------------------

++ echo 10.160.65.202 WS2016
++ modprobe e1000
++ modprobe cifs
++ mount -t debugfs none /sys/kernel/debug
++ echo 'create      cifs.spnego    * * /usr/sbin/cifs.upcall %k'
++ echo 'create      dns_resolver   * * /usr/sbin/cifs.upcall %k'
++ echo 'module cifs +p'
++ echo 'file fs/cifs/* +p'
++ echo 1
++ echo 8
++ echo 1
++ mkdir -p /mnt
++ echo 'echo 1 > /proc/sys/kernel/sysrq && echo o > /proc/sysrq-trigger'
++ chmod a+x /bin/sd
++ mount -t cifs -vvv //WS2016/guestshare /mnt -o ip=10.160.65.202,guest,rw
ip address 10.160.65.202 override specified
mount.cifs kernel mount options: ip=10.160.65.202,unc=\\WS2016\guestshare,user=,pass=********
fs/cifs/cifsfs.c: Devname: //WS2016/guestshare flags: 0
address conversion returned 1 for 10.160.65.202
fs/cifs/connect.c: Anonymous login
fs/cifs/connect.c: file mode: 0x1ed  dir mode: 0x1ed
fs/cifs/connect.c: CIFS VFS: in cifs_mount as Xid: 0 with uid: 0
fs/cifs/connect.c: UNC: \\WS2016\guestshare
fs/cifs/connect.c: Socket created
fs/cifs/connect.c: sndbuf 16384 rcvbuf 87380 rcvtimeo 0x6d6
fs/cifs/connect.c: CIFS VFS: in cifs_get_smb_ses as Xid: 1 with uid: 0
fs/cifs/connect.c: Existing smb sess not found
fs/cifs/cifssmb.c: Requesting extended security.
fs/cifs/transport.c: For smb_command 114
fs/cifs/transport.c: Sending smb: smb_len=69
fs/cifs/connect.c: Demultiplex PID: 153
fs/cifs/connect.c: RFC1002 header 0xcd
fs/cifs/misc.c: checkSMB Length: 0xd1, smb_buf_length: 0xcd
fs/cifs/transport.c: cifs_sync_mid_result: cmd=114 mid=1 state=4
fs/cifs/cifssmb.c: Dialect: 2
Max buf = 16644
fs/cifs/asn1.c: OID len = 10 oid = 0x1 0x3 0x6 0x1
fs/cifs/asn1.c: OID len = 7 oid = 0x1 0x2 0x348 0xbb92
fs/cifs/asn1.c: OID len = 7 oid = 0x1 0x2 0x348 0x1bb92
fs/cifs/asn1.c: OID len = 8 oid = 0x1 0x2 0x348 0x1bb92
fs/cifs/asn1.c: OID len = 10 oid = 0x1 0x3 0x6 0x1
fs/cifs/cifssmb.c: negprot rc 0
fs/cifs/connect.c: Security Mode: 0xf Capabilities: 0x8001f3fc TimeAdjust: 28800
fs/cifs/sess.c: sess setup type 4
fs/cifs/sess.c: rawntlmssp session setup negotiate phase
fs/cifs/transport.c: For smb_command 115
fs/cifs/transport.c: Sending smb: smb_len=184
fs/cifs/connect.c: RFC1002 header 0x163
fs/cifs/misc.c: checkSMB Length: 0x167, smb_buf_length: 0x163
fs/cifs/transport.c: cifs_sync_mid_result: cmd=115 mid=2 state=4
fs/cifs/netmisc.c: Mapping smb error code 0xc0000016 to POSIX err -5
fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
fs/cifs/sess.c: rawntlmssp session setup challenge phase
fs/cifs/sess.c: UID = 8192
fs/cifs/sess.c: rawntlmssp session setup authenticate phase
fs/cifs/transport.c: For smb_command 115
fs/cifs/transport.c: Sending smb: smb_len=400
fs/cifs/connect.c: RFC1002 header 0x23
fs/cifs/misc.c: checkSMB Length: 0x27, smb_buf_length: 0x23
fs/cifs/transport.c: cifs_sync_mid_result: cmd=115 mid=3 state=4
Status code returned 0xc000006d NT_STATUS_LOGON_FAILURE
fs/cifs/netmisc.c: Mapping smb error code 0xc000006d to POSIX err -13
fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
CIFS VFS: Send error in SessSetup = -13
fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses (xid = 1) rc = -13
fs/cifs/connect.c: CIFS VFS: leaving cifs_mount (xid = 0) rc = -13
CIFS VFS: cifs_mount failed w/return code = -13
mount error(13): Permission denied
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
++ sleep 2
++ sd
sysrq: SysRq : Power Off
++ set +x


Generating "/run/initramfs/rdsosreport.txt"
You might want to save "/run/initramfs/rdsosreport.txt" to a USB stick or /boot
after mounting them and attach it to a bug report.

To get more debug information in the report,
reboot with "rd.debug" added to the kernel command line.

Dropping to debug shell.

dracut:/# ACPI: Preparing to enter system sleep state S5
reboot: Power down

--=-=-=
Content-Type: application/vnd.tcpdump.pcap
Content-Disposition: attachment; filename=v4.4_nouser.pcap
Content-Transfer-Encoding: base64

Cg0NClQAAABNPCsaAQAAAP//////////BAAtAFRTaGFyayAxLjEyLjEzIChHaXQgUmV2IFVua25v
d24gZnJvbSB1bmtub3duKQAAAAAAAABUAAAAAQAAACAAAAABAAAAAAAEAAkAAQAGAAAAAAAAACAA
AAAGAAAArAAAAAAAAACFQgUAOF63zosAAACLAAAAUlQA6PCaABY+ZWcJCABFAAB9w3FAAEAG3poK
oEFlCqBByoaiAb1y2R3sMOGkW4AYByF9WgAAAQEICv/+3oUfZNkIAAAARf9TTUJyAAAAAAAByAAA
AAAAAAAAAAAAAAAAlgAAAAEAACIAAkxNMS4yWDAwMgACTEFOTUFOMi4xAAJOVCBMTSAwLjEyAACs
AAAABgAAADQBAAAAAAAAhUIFALpft84TAQAAEwEAAAAWPmVnCVJUAOjwmggARQABBU+yQACABhHS
CqBBygqgQWUBvYaiMOGkW3LZHjWAGCArip4AAAEBCAofZNkK//7ehQAAAM3/U01CcgAAAACAAcgA
AAAAAAAAAAAAAAAAAJYAAAABABECAA8yAAEABEEAAAAAAQAAAAAA/PMBgGC8Z+gYS9IB4AEAiACg
0KhCWhh3TbyiOmkMP5cqYHYGBisGAQUFAqBsMGqgPDA6BgorBgEEAYI3AgIeBgkqhkiC9xIBAgIG
CSqGSIb3EgECAgYKKoZIhvcSAQICAwYKKwYBBAGCNwICCqMqMCigJhskbm90X2RlZmluZWRfaW5f
UkZDNDE3OEBwbGVhc2VfaWdub3JlADQBAAAGAAAAIAEAAAAAAACFQgUAg3G3zv4AAAD+AAAAUlQA
6PCaABY+ZWcJCABFAADww3NAAEAG3iUKoEFlCqBByoaiAb1y2R41MOGlLIAYB2R2IgAAAQEICv/+
3oYfZNkKAAAAuP9TTUJzAAAAAAAF2AAAQlNSU1BZTAAAAAAAlgAAAAIADP8AAABUQDIAAQAAAAAA
IAAAAAAA3NAAgH0ATlRMTVNTUAABAAAAFQII4AAAAAAAAAAAAAAAAAAAAAAATABpAG4AdQB4ACAA
dgBlAHIAcwBpAG8AbgAgADQALgA0AC4AMAAAAEMASQBGAFMAIABWAEYAUwAgAEMAbABpAGUAbgB0
ACAAZgBvAHIAIABMAGkAbgB1AHgAAAAAACABAAAGAAAAzAEAAAAAAACFQgUAgnK3zqkBAACpAQAA
ABY+ZWcJUlQA6PCaCABFAAGbT7NAAIAGETsKoEHKCqBBZQG9hqIw4aUsctke8YAYICpQmAAAAQEI
Ch9k2Q///t6GAAABY/9TTUJzFgAAwIAF2AAAQlNSU1BZTAAAAAAAlgAAIAIABP8AYwEAALAAOAFO
VExNU1NQAAIAAAAIAAgAOAAAABUCieJnMfscw38WCAAAAAAAAAAAcABwAEAAAAAKADk4AAAAD1MA
VQBTAEUAAgAIAFMAVQBTAEUAAQAMAFcAUwAyADAAMQA2AAQADgBzAHUAcwBlAC4AZABlAAMAHABX
AFMAMgAwADEANgAuAHMAdQBzAGUALgBkAGUABQAOAHMAdQBzAGUALgBkAGUABwAIAGC8Z+gYS9IB
AAAAAGdXAGkAbgBkAG8AdwBzACAAUwBlAHIAdgBlAHIAIAAyADAAMQA2ACAAUwB0AGEAbgBkAGEA
cgBkACAAMQA0ADMAOQAzAAAAVwBpAG4AZABvAHcAcwAgAFMAZQByAHYAZQByACAAMgAwADEANgAg
AFMAdABhAG4AZABhAHIAZAAgADYALgAzAAAAAADMAQAABgAAAPgBAAAAAAAAhUIFADiDt87WAQAA
1gEAAFJUAOjwmgAWPmVnCQgARQAByMN0QABABt1MCqBBZQqgQcqGogG9ctke8TDhppOAGAentpsA
AAEBCAr//t6HH2TZDwAAAZD/U01CcwAAAAAABdgAAEJTUlNQWUwAAAAAAJYAACADAAz/AAAAVEAy
AAEAAAAAAPgAAAAAANzQAIBVAU5UTE1TU1AAAwAAAAAAAABAAAAAnACcAEAAAAAIAAgA3AAAAAAA
AADkAAAAAAAAAOYAAAAQABAA6AAAABUCiOBDx/J2/XfEoXCMjcSmIAiZAQEAAAAAAABgvGfoGEvS
AV2uUAuMjg7VAAAAAAIACABTAFUAUwBFAAEADABXAFMAMgAwADEANgAEAA4AcwB1AHMAZQAuAGQA
ZQADABwAVwBTADIAMAAxADYALgBzAHUAcwBlAC4AZABlAAUADgBzAHUAcwBlAC4AZABlAAcACABg
vGfoGEvSAQAAAABTAFUAUwBFAAAAAAAkbI8gUBdeITlc20eNsCYmAEwAaQBuAHUAeAAgAHYAZQBy
AHMAaQBvAG4AIAA0AC4ANAAuADAAAABDAEkARgBTACAAVgBGAFMAIABDAGwAaQBlAG4AdAAgAGYA
bwByACAATABpAG4AdQB4AAAAAAD4AQAABgAAAIwAAAAAAAAAhUIFAMaGt85pAAAAaQAAAAAWPmVn
CVJUAOjwmggARQAAW0+0QACABhJ6CqBBygqgQWUBvYaiMOGmk3LZIIWAGCApoyMAAAEBCAofZNkU
//7ehwAAACP/U01Cc20AAMCABdgAAEJTUlNQWUwAAAAAAJYAACADAAAAAAAAAIwAAAA=
--=-=-=
Content-Type: text/plain
Content-Disposition: attachment; filename=v4.4_user.out

!! BOOT SCRIPT !!
-------------------

++ echo 10.160.65.202 WS2016
++ modprobe e1000
++ modprobe cifs
++ mount -t debugfs none /sys/kernel/debug
++ echo 'create      cifs.spnego    * * /usr/sbin/cifs.upcall %k'
++ echo 'create      dns_resolver   * * /usr/sbin/cifs.upcall %k'
++ echo 'module cifs +p'
++ echo 'file fs/cifs/* +p'
++ echo 1
++ echo 8
++ echo 1
++ mkdir -p /mnt
++ echo 'echo 1 > /proc/sys/kernel/sysrq && echo o > /proc/sysrq-trigger'
++ chmod a+x /bin/sd
++ mount -t cifs -vvv //WS2016/guestshare /mnt -o ip=10.160.65.202,guest,rw,user=abc
ip address 10.160.65.202 override specified
mount.cifs kernel mount options: ip=10.160.65.202,unc=\\WS2016\guestshare,user=abc,pass=********
fs/cifs/cifsfs.c: Devname: //WS2016/guestshare flags: 0
address conversion returned 1 for 10.160.65.202
fs/cifs/connect.c: Username: abc
fs/cifs/connect.c: file mode: 0x1ed  dir mode: 0x1ed
fs/cifs/connect.c: CIFS VFS: in cifs_mount as Xid: 0 with uid: 0
fs/cifs/connect.c: UNC: \\WS2016\guestshare
fs/cifs/connect.c: Socket created
fs/cifs/connect.c: sndbuf 16384 rcvbuf 87380 rcvtimeo 0x6d6
fs/cifs/connect.c: CIFS VFS: in cifs_get_smb_ses as Xid: 1 with uid: 0
fs/cifs/connect.c: Existing smb sess not found
fs/cifs/cifssmb.c: Requesting extended security.
fs/cifs/transport.c: For smb_command 114
fs/cifs/transport.c: Sending smb: smb_len=69
fs/cifs/connect.c: Demultiplex PID: 153
fs/cifs/connect.c: RFC1002 header 0xcd
fs/cifs/misc.c: checkSMB Length: 0xd1, smb_buf_length: 0xcd
fs/cifs/transport.c: cifs_sync_mid_result: cmd=114 mid=1 state=4
fs/cifs/cifssmb.c: Dialect: 2
Max buf = 16644
fs/cifs/asn1.c: OID len = 10 oid = 0x1 0x3 0x6 0x1
fs/cifs/asn1.c: OID len = 7 oid = 0x1 0x2 0x348 0xbb92
fs/cifs/asn1.c: OID len = 7 oid = 0x1 0x2 0x348 0x1bb92
fs/cifs/asn1.c: OID len = 8 oid = 0x1 0x2 0x348 0x1bb92
fs/cifs/asn1.c: OID len = 10 oid = 0x1 0x3 0x6 0x1
fs/cifs/cifssmb.c: negprot rc 0
fs/cifs/connect.c: Security Mode: 0xf Capabilities: 0x8001f3fc TimeAdjust: 28800
fs/cifs/sess.c: sess setup type 4
fs/cifs/sess.c: rawntlmssp session setup negotiate phase
fs/cifs/transport.c: For smb_command 115
fs/cifs/transport.c: Sending smb: smb_len=184
fs/cifs/connect.c: RFC1002 header 0x163
fs/cifs/misc.c: checkSMB Length: 0x167, smb_buf_length: 0x163
fs/cifs/transport.c: cifs_sync_mid_result: cmd=115 mid=2 state=4
fs/cifs/netmisc.c: Mapping smb error code 0xc0000016 to POSIX err -5
fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
fs/cifs/sess.c: rawntlmssp session setup challenge phase
fs/cifs/sess.c: UID = 8193
fs/cifs/sess.c: rawntlmssp session setup authenticate phase
fs/cifs/transport.c: For smb_command 115
fs/cifs/transport.c: Sending smb: smb_len=404
fs/cifs/connect.c: RFC1002 header 0x23
fs/cifs/misc.c: checkSMB Length: 0x27, smb_buf_length: 0x23
fs/cifs/transport.c: cifs_sync_mid_result: cmd=115 mid=3 state=4
Status code returned 0xc000006d NT_STATUS_LOGON_FAILURE
fs/cifs/netmisc.c: Mapping smb error code 0xc000006d to POSIX err -13
fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
CIFS VFS: Send error in SessSetup = -13
fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses (xid = 1) rc = -13
fs/cifs/connect.c: CIFS VFS: leaving cifs_mount (xid = 0) rc = -13
CIFS VFS: cifs_mount failed w/return code = -13
mount error(13): Permission denied
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
++ sleep 2
++ sd
sysrq: SysRq : Power Off
++ set +x


Generating "/run/initramfs/rdsosreport.txt"
You might want to save "/run/initramfs/rdsosreport.txt" to a USB stick or /boot
after mounting them and attach it to a bug report.

To get more debug information in the report,
reboot with "rd.debug" added to the kernel command line.

Dropping to debug shell.

dracut:/# ACPI: Preparing to enter system sleep state S5
reboot: Power down

--=-=-=
Content-Type: application/vnd.tcpdump.pcap
Content-Disposition: attachment; filename=v4.4_user.pcap
Content-Transfer-Encoding: base64

Cg0NClQAAABNPCsaAQAAAP//////////BAAtAFRTaGFyayAxLjEyLjEzIChHaXQgUmV2IFVua25v
d24gZnJvbSB1bmtub3duKQAAAAAAAABUAAAAAQAAACAAAAABAAAAAAAEAAkAAQAGAAAAAAAAACAA
AAAGAAAArAAAAAAAAACFQgUAKGJMz4sAAACLAAAAUlQA6PCaABY+P3O1CABFAAB9UzBAAEAGTqcK
oEGaCqBByuI8Ab3iUY2n/M22qoAYByE98gAAAQEICv/+3ogfZP8uAAAARf9TTUJyAAAAAAAByAAA
AAAAAAAAAAAAAAAAlgAAAAEAACIAAkxNMS4yWDAwMgACTEFOTUFOMi4xAAJOVCBMTSAwLjEyAACs
AAAABgAAADQBAAAAAAAAhUIFAPBjTM8TAQAAEwEAAAAWPj9ztVJUAOjwmggARQABBWQQQACABv0+
CqBBygqgQZoBveI8/M22quJRjfCAGCAr7hEAAAEBCAofZP8w//7eiAAAAM3/U01CcgAAAACAAcgA
AAAAAAAAAAAAAAAAAJYAAAABABECAA8yAAEABEEAAAAAAQAAAAAA/PMBgOvaOe4YS9IB4AEAiACg
0KhCWhh3TbyiOmkMP5cqYHYGBisGAQUFAqBsMGqgPDA6BgorBgEEAYI3AgIeBgkqhkiC9xIBAgIG
CSqGSIb3EgECAgYKKoZIhvcSAQICAwYKKwYBBAGCNwICCqMqMCigJhskbm90X2RlZmluZWRfaW5f
UkZDNDE3OEBwbGVhc2VfaWdub3JlADQBAAAGAAAAIAEAAAAAAACFQgUA63ZMz/4AAAD+AAAAUlQA
6PCaABY+P3O1CABFAADwUzJAAEAGTjIKoEGaCqBByuI8Ab3iUY3w/M23e4AYB2Q2uQAAAQEICv/+
3oofZP8wAAAAuP9TTUJzAAAAAAAF2AAAQlNSU1BZTAAAAAAAlgAAAAIADP8AAABUQDIAAQAAAAAA
IAAAAAAA3NAAgH0ATlRMTVNTUAABAAAAFQII4AAAAAAAAAAAAAAAAAAAAAAATABpAG4AdQB4ACAA
dgBlAHIAcwBpAG8AbgAgADQALgA0AC4AMAAAAEMASQBGAFMAIABWAEYAUwAgAEMAbABpAGUAbgB0
ACAAZgBvAHIAIABMAGkAbgB1AHgAAAAAACABAAAGAAAAzAEAAAAAAACFQgUAyXdMz6kBAACpAQAA
ABY+P3O1UlQA6PCaCABFAAGbZBFAAIAG/KcKoEHKCqBBmgG94jz8zbd74lGOrIAYICqXwgAAAQEI
Ch9k/zX//t6KAAABY/9TTUJzFgAAwIAF2AAAQlNSU1BZTAAAAAAAlgABIAIABP8AYwEAALAAOAFO
VExNU1NQAAIAAAAIAAgAOAAAABUCieJuamEeMKJInQAAAAAAAAAAcABwAEAAAAAKADk4AAAAD1MA
VQBTAEUAAgAIAFMAVQBTAEUAAQAMAFcAUwAyADAAMQA2AAQADgBzAHUAcwBlAC4AZABlAAMAHABX
AFMAMgAwADEANgAuAHMAdQBzAGUALgBkAGUABQAOAHMAdQBzAGUALgBkAGUABwAIAEQ9PO4YS9IB
AAAAAA5XAGkAbgBkAG8AdwBzACAAUwBlAHIAdgBlAHIAIAAyADAAMQA2ACAAUwB0AGEAbgBkAGEA
cgBkACAAMQA0ADMAOQAzAAAAVwBpAG4AZABvAHcAcwAgAFMAZQByAHYAZQByACAAMgAwADEANgAg
AFMAdABhAG4AZABhAHIAZAAgADYALgAzAAAAAADMAQAABgAAAPwBAAAAAAAAhUIFAKiHTM/aAQAA
2gEAAFJUAOjwmgAWPj9ztQgARQABzFMzQABABk1VCqBBmgqgQcriPAG94lGOrPzNuOKAGAendVkA
AAEBCAr//t6LH2T/NQAAAZT/U01CcwAAAAAABdgAAEJTUlNQWUwAAAAAAJYAASADAAz/AAAAVEAy
AAEAAAAAAPwAAAAAANzQAIBZAU5UTE1TU1AAAwAAAAAAAABAAAAAnACcAEAAAAAIAAgA3AAAAAYA
BgDkAAAAAAAAAOoAAAAQABAA7AAAABUCiOC96Fatq4mjuy6jZkZ1gCHhAQEAAAAAAABEPTzuGEvS
AQ3HXuTHkBXYAAAAAAIACABTAFUAUwBFAAEADABXAFMAMgAwADEANgAEAA4AcwB1AHMAZQAuAGQA
ZQADABwAVwBTADIAMAAxADYALgBzAHUAcwBlAC4AZABlAAUADgBzAHUAcwBlAC4AZABlAAcACABE
PTzuGEvSAQAAAABTAFUAUwBFAGEAYgBjAAAAWk+6neVXyjzQM75/1X8zwgBMAGkAbgB1AHgAIAB2
AGUAcgBzAGkAbwBuACAANAAuADQALgAwAAAAQwBJAEYAUwAgAFYARgBTACAAQwBsAGkAZQBuAHQA
IABmAG8AcgAgAEwAaQBuAHUAeAAAAAAA/AEAAAYAAACMAAAAAAAAAIVCBQAWi0zPaQAAAGkAAAAA
Fj4/c7VSVADo8JoIAEUAAFtkEkAAgAb95gqgQcoKoEGaAb3iPPzNuOLiUZBEgBggKWK2AAABAQgK
H2T/Ov/+3osAAAAj/1NNQnNtAADAgAXYAABCU1JTUFlMAAAAAACWAAEgAwAAAAAAAACMAAAA
--=-=-=
Content-Type: text/plain
Content-Disposition: attachment; filename=master_nouser.out

!! BOOT SCRIPT !!
-------------------

++ echo 10.160.65.202 WS2016
++ modprobe e1000
++ modprobe cifs
++ mount -t debugfs none /sys/kernel/debug
++ echo 'create      cifs.spnego    * * /usr/sbin/cifs.upcall %k'
++ echo 'create      dns_resolver   * * /usr/sbin/cifs.upcall %k'
++ echo 'module cifs +p'
++ echo 'file fs/cifs/* +p'
++ echo 1
++ echo 8
++ echo 1
++ mkdir -p /mnt
++ echo 'echo 1 > /proc/sys/kernel/sysrq && echo o > /proc/sysrq-trigger'random: fast init done

++ chmod a+x /bin/sd
++ mount -t cifs -vvv //WS2016/guestshare /mnt -o ip=10.160.65.202,guest,rw
ip address 10.160.65.202 override specified
mount.cifs kernel mount options: ip=10.160.65.202,unc=\\WS2016\guestshare,user=,pass=********
fs/cifs/cifsfs.c: Devname: //WS2016/guestshare flags: 0
address conversion returned 1 for 10.160.65.202
fs/cifs/connect.c: Anonymous login
fs/cifs/connect.c: file mode: 0x1ed  dir mode: 0x1ed
fs/cifs/connect.c: CIFS VFS: in cifs_mount as Xid: 0 with uid: 0
fs/cifs/connect.c: UNC: \\WS2016\guestshare
fs/cifs/connect.c: Socket created
fs/cifs/connect.c: sndbuf 16384 rcvbuf 87380 rcvtimeo 0x6d6
fs/cifs/connect.c: CIFS VFS: in cifs_get_smb_ses as Xid: 1 with uid: 0
fs/cifs/connect.c: Existing smb sess not found
fs/cifs/cifssmb.c: Requesting extended security.fs/cifs/transport.c: For smb_command 114
fs/cifs/transport.c: Sending smb: smb_len=69
fs/cifs/connect.c: Demultiplex PID: 153
fs/cifs/connect.c: RFC1002 header 0xcd
fs/cifs/misc.c: checkSMB Length: 0xd1, smb_buf_length: 0xcd
fs/cifs/transport.c: cifs_sync_mid_result: cmd=114 mid=1 state=4
fs/cifs/cifssmb.c: Dialect: 2
Max buf = 16644
fs/cifs/asn1.c: OID len = 10 oid = 0x1 0x3 0x6 0x1
fs/cifs/asn1.c: OID len = 7 oid = 0x1 0x2 0x348 0xbb92
fs/cifs/asn1.c: OID len = 7 oid = 0x1 0x2 0x348 0x1bb92
fs/cifs/asn1.c: OID len = 8 oid = 0x1 0x2 0x348 0x1bb92
fs/cifs/asn1.c: OID len = 10 oid = 0x1 0x3 0x6 0x1
fs/cifs/cifssmb.c: negprot rc 0
fs/cifs/connect.c: Security Mode: 0xf Capabilities: 0x8001f3fc TimeAdjust: 28800
fs/cifs/sess.c: sess setup type 4
fs/cifs/sess.c: rawntlmssp session setup negotiate phase
fs/cifs/transport.c: For smb_command 115
fs/cifs/transport.c: Sending smb: smb_len=194
fs/cifs/connect.c: RFC1002 header 0x163
fs/cifs/misc.c: checkSMB Length: 0x167, smb_buf_length: 0x163
fs/cifs/transport.c: cifs_sync_mid_result: cmd=115 mid=2 state=4
fs/cifs/netmisc.c: Mapping smb error code 0xc0000016 to POSIX err -5
fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
fs/cifs/sess.c: rawntlmssp session setup challenge phase
fs/cifs/sess.c: UID = 8192
fs/cifs/sess.c: rawntlmssp session setup authenticate phase
fs/cifs/transport.c: For smb_command 115
fs/cifs/transport.c: Sending smb: smb_len=254
fs/cifs/connect.c: RFC1002 header 0xb3
fs/cifs/misc.c: checkSMB Length: 0xb7, smb_buf_length: 0xb3
fs/cifs/transport.c: cifs_sync_mid_result: cmd=115 mid=3 state=4
fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
fs/cifs/sess.c: bleft 135
fs/cifs/sess.c: serverOS=Windows Server 2016 Standard 14393
fs/cifs/sess.c: serverNOS=Windows Server 2016 Standard 6.3
fs/cifs/sess.c: CIFS session established successfully
fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses (xid = 1) rc = 0
fs/cifs/connect.c: CIFS VFS: in cifs_get_tcon as Xid: 2 with uid: 0
fs/cifs/transport.c: For smb_command 117
fs/cifs/transport.c: Sending smb: smb_len=90
fs/cifs/connect.c: RFC1002 header 0x23
fs/cifs/misc.c: checkSMB Length: 0x27, smb_buf_length: 0x23
fs/cifs/transport.c: cifs_sync_mid_result: cmd=117 mid=4 state=4
CIFS VFS: SMB signature verification returned error = -13
fs/cifs/netmisc.c: Mapping smb error code 0xc0000022 to POSIX err -13
fs/cifs/connect.c: CIFS VFS: leaving cifs_get_tcon (xid = 2) rc = -13
fs/cifs/connect.c: Tcon rc = -13
fs/cifs/connect.c: build_unc_path_to_root: full_path=\\WS2016\guestshare
fs/cifs/transport.c: For smb_command 117
fs/cifs/transport.c: Sending smb: smb_len=92
fs/cifs/connect.c: RFC1002 header 0x38
fs/cifs/misc.c: checkSMB Length: 0x3c, smb_buf_length: 0x38
fs/cifs/transport.c: cifs_sync_mid_result: cmd=117 mid=5 state=4
CIFS VFS: SMB signature verification returned error = -13
fs/cifs/connect.c: Tcon rc = 0 ipc_tid = 4100
fs/cifs/cifssmb.c: In GetDFSRefer the path \WS2016\guestshare
fs/cifs/transport.c: For smb_command 50
fs/cifs/transport.c: Sending smb: smb_len=108
fs/cifs/connect.c: RFC1002 header 0x23
fs/cifs/misc.c: checkSMB Length: 0x27, smb_buf_length: 0x23
fs/cifs/smb1ops.c: invalid transact2 word count
fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=6 state=4
CIFS VFS: SMB signature verification returned error = -13
fs/cifs/netmisc.c: Mapping smb error code 0xc0000225 to POSIX err -5
fs/cifs/cifssmb.c: Send error in GetDFSRefer = -5
fs/cifs/connect.c: cifs_put_smb_ses: ses_count=1
fs/cifs/connect.c: CIFS VFS: in cifs_put_smb_ses as Xid: 3 with uid: 0
fs/cifs/cifssmb.c: In SMBLogoff for session disconnect
fs/cifs/transport.c: For smb_command 116
fs/cifs/transport.c: Sending smb: smb_len=39
fs/cifs/connect.c: RFC1002 header 0x27
fs/cifs/misc.c: checkSMB Length: 0x2b, smb_buf_length: 0x27
fs/cifs/transport.c: cifs_sync_mid_result: cmd=116 mid=7 state=4
CIFS VFS: SMB signature verification returned error = -13
SendRcvNoRsp flags 64 rc 0
fs/cifs/connect.c: CIFS VFS: leaving cifs_mount (xid = 0) rc = -13
CIFS VFS: cifs_mount failed w/return code = -13
mount error(13): Permission denied
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
++ sleep 2
++ sd
sysrq: SysRq : Power Off
++ set +x


Generating "/run/initramfs/rdsosreport.txt"
You might want to save "/run/initramfs/rdsosreport.txt" to a USB stick or /boot
after mounting them and attach it to a bug report.

To get more debug information in the report,
reboot with "rd.debug" added to the kernel command line.

Dropping to debug shell.

dracut:/# ACPI: Preparing to enter system sleep state S5
reboot: Power down

--=-=-=
Content-Type: application/vnd.tcpdump.pcap
Content-Disposition: attachment; filename=master_nouser.pcap
Content-Transfer-Encoding: base64

Cg0NClQAAABNPCsaAQAAAP//////////BAAtAFRTaGFyayAxLjEyLjEzIChHaXQgUmV2IFVua25v
d24gZnJvbSB1bmtub3duKQAAAAAAAABUAAAAAQAAACAAAAABAAAAAAAEAAkAAQAGAAAAAAAAACAA
AAAGAAAArAAAAAAAAACFQgUAkCpQ2YsAAACLAAAAUlQA6PCaABY+W7CDCABFAAB9jKZAAEAGFUIK
oEGJCqBBytGyAb32E1I4fLbUYIAYByFIOgAAAQEICv/+3pMfZ4+CAAAARf9TTUJyAAAAAAAByAAA
AAAAAAAAAAAAAAAAlgAAAAEAACIAAkxNMS4yWDAwMgACTEFOTUFOMi4xAAJOVCBMTSAwLjEyAACs
AAAABgAAADQBAAAAAAAAhUIFACQsUNkTAQAAEwEAAAAWPluwg1JUAOjwmggARQABBSiJQACABjjX
CqBBygqgQYkBvdGyfLbUYPYTUoGAGCAr+s8AAAEBCAofZ4+E//7ekwAAAM3/U01CcgAAAACAAcgA
AAAAAAAAAAAAAAAAAJYAAAABABECAA8yAAEABEEAAAAAAQAAAAAA/PMBgMMAX1IZS9IB4AEAiACg
0KhCWhh3TbyiOmkMP5cqYHYGBisGAQUFAqBsMGqgPDA6BgorBgEEAYI3AgIeBgkqhkiC9xIBAgIG
CSqGSIb3EgECAgYKKoZIhvcSAQICAwYKKwYBBAGCNwICCqMqMCigJhskbm90X2RlZmluZWRfaW5f
UkZDNDE3OEBwbGVhc2VfaWdub3JlADQBAAAGAAAAKAEAAAAAAACFQgUAdT1Q2QgBAAAIAQAAUlQA
6PCaABY+W7CDCABFAAD6jKhAAEAGFMMKoEGJCqBBytGyAb32E1KBfLbVMYAYB2TZ4gAAAQEICv/+
3pQfZ4+EAAAAwv9TTUJzAAAAAAAF2AAAQlNSU1BZTAAAAAAAlgAAAAIADP8AAABUQDIAAQAAAAAA
IAAAAAAA3NAAgIcATlRMTVNTUAABAAAAFQII4AAAAAAAAAAAAAAAAAAAAAAATABpAG4AdQB4ACAA
dgBlAHIAcwBpAG8AbgAgADQALgA5AC4AMAAtAHIAYwA1ACsAAABDAEkARgBTACAAVgBGAFMAIABD
AGwAaQBlAG4AdAAgAGYAbwByACAATABpAG4AdQB4AAAAKAEAAAYAAADMAQAAAAAAAIVCBQBMPlDZ
qQEAAKkBAAAAFj5bsINSVADo8JoIAEUAAZsoikAAgAY4QAqgQcoKoEGJAb3Rsny21TH2E1NHgBgg
KpxsAAABAQgKH2ePif/+3pQAAAFj/1NNQnMWAADAgAXYAABCU1JTUFlMAAAAAACWAAAgAgAE/wBj
AQAAsAA4AU5UTE1TU1AAAgAAAAgACAA4AAAAFQKJ4kbQTVjCP4DcAAAAAAAAAABwAHAAQAAAAAoA
OTgAAAAPUwBVAFMARQACAAgAUwBVAFMARQABAAwAVwBTADIAMAAxADYABAAOAHMAdQBzAGUALgBk
AGUAAwAcAFcAUwAyADAAMQA2AC4AcwB1AHMAZQAuAGQAZQAFAA4AcwB1AHMAZQAuAGQAZQAHAAgA
6mJhUhlL0gEAAAAASVcAaQBuAGQAbwB3AHMAIABTAGUAcgB2AGUAcgAgADIAMAAxADYAIABTAHQA
YQBuAGQAYQByAGQAIAAxADQAMwA5ADMAAABXAGkAbgBkAG8AdwBzACAAUwBlAHIAdgBlAHIAIAAy
ADAAMQA2ACAAUwB0AGEAbgBkAGEAcgBkACAANgAuADMAAAAAAMwBAAAGAAAAZAEAAAAAAACFQgUA
ZUxQ2UQBAABEAQAAUlQA6PCaABY+W7CDCABFAAE2jKlAAEAGFIYKoEGJCqBBytGyAb32E1NHfLbW
mIAYB6cjTgAAAQEICv/+3pUfZ4+JAAAA/v9TTUJzAAAAAAAF2AAAQlNSU1BZTAAAAAAAlgAAIAMA
DP8AAABUQDIAAQAAAAAAXAAAAAAA3NAAgMMATlRMTVNTUAADAAAAAAAAAEAAAAAAAAAAQAAAAAgA
CABAAAAAAAAAAEgAAAAAAAAASgAAABAAEABMAAAAFQKI4FMAVQBTAEUAAAAAAIoyJjh8SOAle5SH
ykOpKs0ATABpAG4AdQB4ACAAdgBlAHIAcwBpAG8AbgAgADQALgA5AC4AMAAtAHIAYwA1ACsAAABD
AEkARgBTACAAVgBGAFMAIABDAGwAaQBlAG4AdAAgAGYAbwByACAATABpAG4AdQB4AAAAZAEAAAYA
AAAcAQAAAAAAAIVCBQDrTVDZ+QAAAPkAAAAAFj5bsINSVADo8JoIAEUAAOsoi0AAgAY47wqgQcoK
oEGJAb3Rsny21pj2E1RJgBggKdSKAAABAQgKH2ePjf/+3pUAAACz/1NNQnMAAAAAgAXYAABCU1JT
UFlMAAAAAACWAAAgAwAE/wCzAAAAAACIAABXAGkAbgBkAG8AdwBzACAAUwBlAHIAdgBlAHIAIAAy
ADAAMQA2ACAAUwB0AGEAbgBkAGEAcgBkACAAMQA0ADMAOQAzAAAAVwBpAG4AZABvAHcAcwAgAFMA
ZQByAHYAZQByACAAMgAwADEANgAgAFMAdABhAG4AZABhAHIAZAAgADYALgAzAAAAAAAcAQAABgAA
AMAAAAAAAAAAhUIFAGlcUNmgAAAAoAAAAFJUAOjwmgAWPluwgwgARQAAkoyqQABABhUpCqBBiQqg
QcrRsgG99hNUSXy210+AGAfqJfAAAAEBCAr//t6WH2ePjQAAAFr/U01CdQAAAAAABdAAAOaHmjoL
OT3zAAAAAJYAACAEAAT/AAAACAABAC8AAFwAXABXAFMAMgAwADEANgBcAGcAdQBlAHMAdABzAGgA
YQByAGUAAAA/Pz8/PwDAAAAABgAAAIwAAAAAAAAAhUIFAOhcUNlpAAAAaQAAAAAWPluwg1JUAOjw
mggARQAAWyiMQACABjl+CqBBygqgQYkBvdGyfLbXT/YTVKeAGCAp0dYAAAEBCAofZ4+R//7elgAA
ACP/U01CdSIAAMCABdAAAOaHmjoLOT3zAAAAAJYAACAEAAAAAAAAAIwAAAAGAAAAxAAAAAAAAACF
QgUAtGhQ2aIAAACiAAAAUlQA6PCaABY+W7CDCABFAACUjKtAAEAGFSYKoEGJCqBBytGyAb32E1Sn
fLbXdoAYB+ph/wAAAQEICv/+3pcfZ4+RAAAAXP9TTUJ1AAAAAAAF0AAANam09YgcRpYAAAAAlgAA
IAUABP8AAAAIAAEAMQAAXABcADEAMAAuADEANgAwAC4ANgA1AC4AMgAwADIAXABJAFAAQwAkAAAA
Pz8/Pz8AAADEAAAABgAAAKAAAAAAAAAAhUIFACtpUNl+AAAAfgAAAAAWPluwg1JUAOjwmggARQAA
cCiNQACABjloCqBBygqgQYkBvdGyfLbXdvYTVQeAGCAoQ8kAAAEBCAofZ4+U//7elwAAADj/U01C
dQAAAACABdAAADWptPWIHEaWAAAEEJYAACAFAAf/ADgAAQD//x8A//8fAAcASVBDAAAAAAAAoAAA
AAYAAADUAAAAAAAAAIVCBQBAclDZsgAAALIAAABSVADo8JoAFj5bsIMIAEUAAKSMrEAAQAYVFQqg
QYkKoEHK0bIBvfYTVQd8tteygBgH6r9QAAABAQgK//7emB9nj5QAAABs/1NNQjIAAAAAAAXQAAC6
nkwWOuEm4AAABBCWAAAgBgAPKAAAAAAAoA8AAAAAAAAAAAAAKABEAAAAAAABABAAKwAAAAADAFwA
VwBTADIAMAAxADYAXABnAHUAZQBzAHQAcwBoAGEAcgBlAAAAAADUAAAABgAAAIwAAAAAAAAAhUIF
AGh/UNlpAAAAaQAAAAAWPluwg1JUAOjwmggARQAAWyiOQACABjl8CqBBygqgQYkBvdGyfLbXsvYT
VXeAGCAobQAAAAEBCAofZ4+Z//7emAAAACP/U01CMiUCAMCABdAAALqeTBY64SbgAAAEEJYAACAG
AAAAAAAAAIwAAAAGAAAAkAAAAAAAAACFQgUAbI1Q2W0AAABtAAAAUlQA6PCaABY+W7CDCABFAABf
jK1AAEAGFVkKoEGJCqBBytGyAb32E1V3fLbX2YAYB+pbXgAAAQEICv/+3pkfZ4+ZAAAAJ/9TTUJ0
AAAAAAAFAAAAv9JUlGRRmvQAAAAAlgAAIAcAAv8AAAAAAAAAAJAAAAAGAAAAkAAAAAAAAACFQgUA
+41Q2W0AAABtAAAAABY+W7CDUlQA6PCaCABFAABfKI9AAIAGOXcKoEHKCqBBiQG90bJ8ttfZ9hNV
ooAYIChCSgAAAQEICh9nj53//t6ZAAAAJ/9TTUJ0AAAAAIAFAAAAv9JUlGRRmvQAAAAAlgAAIAcA
Av8AJwAAAAAAAJAAAAA=
--=-=-=
Content-Type: text/plain
Content-Disposition: attachment; filename=master_user.out

!! BOOT SCRIPT !!
-------------------

++ echo 10.160.65.202 WS2016
++ modprobe e1000
++ modprobe cifs
++ mount -t debugfs none /sys/kernel/debug
++ echo 'create      cifs.spnego    * * /usr/sbin/cifs.upcall %k'
++ echo 'create      dns_resolver   * * /usr/sbin/cifs.upcall %k'
++ echo 'module cifs +p'
++ echo 'file fs/cifs/* +p'
++ echo 1
++ echo 8
++ echo 1
++ mkdir -p /mnt
++ echo 'echo 1 > /proc/sys/kernel/sysrq && echo o > /proc/sysrq-trigger'
++ chmod a+x /bin/sd
++ mount -t cifs -vvv //WS2016/guestshare /mnt -o ip=10.160.65.202,guest,rw,user=abc
random: fast init done
ip address 10.160.65.202 override specified
mount.cifs kernel mount options: ip=10.160.65.202,unc=\\WS2016\guestshare,user=abc,pass=********
fs/cifs/cifsfs.c: Devname: //WS2016/guestshare flags: 0
address conversion returned 1 for 10.160.65.202
fs/cifs/connect.c: Username: abc
fs/cifs/connect.c: file mode: 0x1ed  dir mode: 0x1ed
fs/cifs/connect.c: CIFS VFS: in cifs_mount as Xid: 0 with uid: 0
fs/cifs/connect.c: UNC: \\WS2016\guestshare
fs/cifs/connect.c: Socket created
fs/cifs/connect.c: sndbuf 16384 rcvbuf 87380 rcvtimeo 0x6d6
fs/cifs/connect.c: CIFS VFS: in cifs_get_smb_ses as Xid: 1 with uid: 0
fs/cifs/connect.c: Existing smb sess not found
fs/cifs/cifssmb.c: Requesting extended security.fs/cifs/transport.c: For smb_command 114
fs/cifs/transport.c: Sending smb: smb_len=69
fs/cifs/connect.c: Demultiplex PID: 153
fs/cifs/connect.c: RFC1002 header 0xcd
fs/cifs/misc.c: checkSMB Length: 0xd1, smb_buf_length: 0xcd
fs/cifs/transport.c: cifs_sync_mid_result: cmd=114 mid=1 state=4
fs/cifs/cifssmb.c: Dialect: 2
Max buf = 16644
fs/cifs/asn1.c: OID len = 10 oid = 0x1 0x3 0x6 0x1
fs/cifs/asn1.c: OID len = 7 oid = 0x1 0x2 0x348 0xbb92
fs/cifs/asn1.c: OID len = 7 oid = 0x1 0x2 0x348 0x1bb92
fs/cifs/asn1.c: OID len = 8 oid = 0x1 0x2 0x348 0x1bb92
fs/cifs/asn1.c: OID len = 10 oid = 0x1 0x3 0x6 0x1
fs/cifs/cifssmb.c: negprot rc 0
fs/cifs/connect.c: Security Mode: 0xf Capabilities: 0x8001f3fc TimeAdjust: 28800
fs/cifs/sess.c: sess setup type 4
fs/cifs/sess.c: rawntlmssp session setup negotiate phase
fs/cifs/transport.c: For smb_command 115
fs/cifs/transport.c: Sending smb: smb_len=194
fs/cifs/connect.c: RFC1002 header 0x163
fs/cifs/misc.c: checkSMB Length: 0x167, smb_buf_length: 0x163
fs/cifs/transport.c: cifs_sync_mid_result: cmd=115 mid=2 state=4
fs/cifs/netmisc.c: Mapping smb error code 0xc0000016 to POSIX err -5
fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
fs/cifs/sess.c: rawntlmssp session setup challenge phase
fs/cifs/sess.c: UID = 8192
fs/cifs/sess.c: rawntlmssp session setup authenticate phase
fs/cifs/transport.c: For smb_command 115
fs/cifs/transport.c: Sending smb: smb_len=414
fs/cifs/connect.c: RFC1002 header 0x23
fs/cifs/misc.c: checkSMB Length: 0x27, smb_buf_length: 0x23
fs/cifs/transport.c: cifs_sync_mid_result: cmd=115 mid=3 state=4
Status code returned 0xc000006d NT_STATUS_LOGON_FAILURE
fs/cifs/netmisc.c: Mapping smb error code 0xc000006d to POSIX err -13
fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
CIFS VFS: Send error in SessSetup = -13
fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses (xid = 1) rc = -13
fs/cifs/connect.c: CIFS VFS: leaving cifs_mount (xid = 0) rc = -13
CIFS VFS: cifs_mount failed w/return code = -13
mount error(13): Permission denied
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
++ sleep 2
++ sd
sysrq: SysRq : Power Off
++ set +x


Generating "/run/initramfs/rdsosreport.txt"
You might want to save "/run/initramfs/rdsosreport.txt" to a USB stick or /boot
after mounting them and attach it to a bug report.

To get more debug information in the report,
reboot with "rd.debug" added to the kernel command line.

Dropping to debug shell.

dracut:/# ACPI: Preparing to enter system sleep state S5
reboot: Power down

--=-=-=
Content-Type: application/vnd.tcpdump.pcap
Content-Disposition: attachment; filename=master_user.pcap
Content-Transfer-Encoding: base64

Cg0NClQAAABNPCsaAQAAAP//////////BAAtAFRTaGFyayAxLjEyLjEzIChHaXQgUmV2IFVua25v
d24gZnJvbSB1bmtub3duKQAAAAAAAABUAAAAAQAAACAAAAABAAAAAAAEAAkAAQAGAAAAAAAAACAA
AAAGAAAArAAAAAAAAACFQgUAsJjj2YsAAACLAAAAUlQA6PCaABY+KastCABFAAB9UFdAAEAGUl0K
oEC9CqBByoSkAb2YsI7fKZ7BwYAYByH20AAAAQEICv/+3owfZ7VAAAAARf9TTUJyAAAAAAAByAAA
AAAAAAAAAAAAAAAAlgAAAAEAACIAAkxNMS4yWDAwMgACTEFOTUFOMi4xAAJOVCBMTSAwLjEyAACs
AAAABgAAADQBAAAAAAAAhUIFAFia49kTAQAAEwEAAAAWPimrLVJUAOjwmggARQABBTQZQACABi4T
CqBBygqgQL0BvYSkKZ7BwZiwjyiAGCArQJAAAAEBCAofZ7VC//7ejAAAAM3/U01CcgAAAACAAcgA
AAAAAAAAAAAAAAAAAJYAAAABABECAA8yAAEABEEAAAAAAQAAAAAA/PMBgGjRIlgZS9IB4AEAiACg
0KhCWhh3TbyiOmkMP5cqYHYGBisGAQUFAqBsMGqgPDA6BgorBgEEAYI3AgIeBgkqhkiC9xIBAgIG
CSqGSIb3EgECAgYKKoZIhvcSAQICAwYKKwYBBAGCNwICCqMqMCigJhskbm90X2RlZmluZWRfaW5f
UkZDNDE3OEBwbGVhc2VfaWdub3JlADQBAAAGAAAAKAEAAAAAAACFQgUA6qrj2QgBAAAIAQAAUlQA
6PCaABY+KastCABFAAD6UFlAAEAGUd4KoEC9CqBByoSkAb2YsI8oKZ7CkoAYB2SIeQAAAQEICv/+
3o0fZ7VCAAAAwv9TTUJzAAAAAAAF2AAAQlNSU1BZTAAAAAAAlgAAAAIADP8AAABUQDIAAQAAAAAA
IAAAAAAA3NAAgIcATlRMTVNTUAABAAAAFQII4AAAAAAAAAAAAAAAAAAAAAAATABpAG4AdQB4ACAA
dgBlAHIAcwBpAG8AbgAgADQALgA5AC4AMAAtAHIAYwA1ACsAAABDAEkARgBTACAAVgBGAFMAIABD
AGwAaQBlAG4AdAAgAGYAbwByACAATABpAG4AdQB4AAAAKAEAAAYAAADMAQAAAAAAAIVCBQDOq+PZ
qQEAAKkBAAAAFj4pqy1SVADo8JoIAEUAAZs0GkAAgAYtfAqgQcoKoEC9Ab2EpCmewpKYsI/ugBgg
KmYlAAABAQgKH2e1R//+3o0AAAFj/1NNQnMWAADAgAXYAABCU1JTUFlMAAAAAACWAAAgAgAE/wBj
AQAAsAA4AU5UTE1TU1AAAgAAAAgACAA4AAAAFQKJ4k2ES0ww+/TpAAAAAAAAAABwAHAAQAAAAAoA
OTgAAAAPUwBVAFMARQACAAgAUwBVAFMARQABAAwAVwBTADIAMAAxADYABAAOAHMAdQBzAGUALgBk
AGUAAwAcAFcAUwAyADAAMQA2AC4AcwB1AHMAZQAuAGQAZQAFAA4AcwB1AHMAZQAuAGQAZQAHAAgA
aNEiWBlL0gEAAAAAAFcAaQBuAGQAbwB3AHMAIABTAGUAcgB2AGUAcgAgADIAMAAxADYAIABTAHQA
YQBuAGQAYQByAGQAIAAxADQAMwA5ADMAAABXAGkAbgBkAG8AdwBzACAAUwBlAHIAdgBlAHIAIAAy
ADAAMQA2ACAAUwB0AGEAbgBkAGEAcgBkACAANgAuADMAAAAAAMwBAAAGAAAABAIAAAAAAACFQgUA
D7rj2eQBAADkAQAAUlQA6PCaABY+KastCABFAAHWUFpAAEAGUQEKoEC9CqBByoSkAb2YsI/uKZ7D
+YAYB6cdxQAAAQEICv/+3o4fZ7VHAAABnv9TTUJzAAAAAAAF2AAAQlNSU1BZTAAAAAAAlgAAIAMA
DP8AAABUQDIAAQAAAAAA/AAAAAAA3NAAgGMBTlRMTVNTUAADAAAAAAAAAEAAAACcAJwAQAAAAAgA
CADcAAAABgAGAOQAAAAAAAAA6gAAABAAEADsAAAAFQKI4KTAW9JSfT8DKkbxnacYCV8BAQAAAAAA
AGjRIlgZS9IBzsEr9T5dLHkAAAAAAgAIAFMAVQBTAEUAAQAMAFcAUwAyADAAMQA2AAQADgBzAHUA
cwBlAC4AZABlAAMAHABXAFMAMgAwADEANgAuAHMAdQBzAGUALgBkAGUABQAOAHMAdQBzAGUALgBk
AGUABwAIAGjRIlgZS9IBAAAAAFMAVQBTAEUAYQBiAGMAAAAufRuuvhBehdg1geUWgdAFAEwAaQBu
AHUAeAAgAHYAZQByAHMAaQBvAG4AIAA0AC4AOQAuADAALQByAGMANQArAAAAQwBJAEYAUwAgAFYA
RgBTACAAQwBsAGkAZQBuAHQAIABmAG8AcgAgAEwAaQBuAHUAeAAAAAQCAAAGAAAAjAAAAAAAAACF
QgUA5Lzj2WkAAABpAAAAABY+KastUlQA6PCaCABFAABbNBtAAIAGLrsKoEHKCqBAvQG9hKQpnsP5
mLCRkIAYICkcgwAAAQEICh9ntUv//t6OAAAAI/9TTUJzbQAAwIAF2AAAQlNSU1BZTAAAAAAAlgAA
IAMAAAAAAAAAjAAAAA==
--=-=-=
Content-Type: text/plain
Content-Disposition: attachment; filename=ml-guestfix_nouser.out

!! BOOT SCRIPT !!
-------------------

++ echo 10.160.65.202 WS2016
++ modprobe e1000
++ modprobe cifs
++ mount -t debugfs none /sys/kernel/debug
++ echo 'create      cifs.spnego    * * /usr/sbin/cifs.upcall %k'
++ echo 'create      dns_resolver   * * /usr/sbin/cifs.upcall %k'
++ echo 'module cifs +p'
++ echo 'file fs/cifs/* +p'
++ echo 1
++ echo 8
++ echo 1
++ mkdir -p /mnt
++ echo 'echo 1 > /proc/sys/kernel/sysrq && echo o > /proc/sysrq-trigger'
++ chmod a+x /bin/sd
++ mount -t cifs -vvv //WS2016/guestshare /mnt -o ip=10.160.65.202,guest,rw
ip address 10.160.65.202 override specified
random: fast init done
mount.cifs kernel mount options: ip=10.160.65.202,unc=\\WS2016\guestshare,user=,pass=********
fs/cifs/cifsfs.c: Devname: //WS2016/guestshare flags: 0
address conversion returned 1 for 10.160.65.202
fs/cifs/connect.c: Anonymous login
fs/cifs/connect.c: file mode: 0x1ed  dir mode: 0x1ed
fs/cifs/connect.c: CIFS VFS: in cifs_mount as Xid: 0 with uid: 0
fs/cifs/connect.c: UNC: \\WS2016\guestshare
fs/cifs/connect.c: Socket created
fs/cifs/connect.c: sndbuf 16384 rcvbuf 87380 rcvtimeo 0x6d6
fs/cifs/connect.c: CIFS VFS: in cifs_get_smb_ses as Xid: 1 with uid: 0
fs/cifs/connect.c: Existing smb sess not found
fs/cifs/cifssmb.c: Requesting extended security.fs/cifs/transport.c: For smb_command 114
fs/cifs/transport.c: Sending smb: smb_len=69
fs/cifs/connect.c: Demultiplex PID: 153
fs/cifs/connect.c: RFC1002 header 0xcd
fs/cifs/misc.c: checkSMB Length: 0xd1, smb_buf_length: 0xcd
fs/cifs/transport.c: cifs_sync_mid_result: cmd=114 mid=1 state=4
fs/cifs/cifssmb.c: Dialect: 2
Max buf = 16644
fs/cifs/asn1.c: OID len = 10 oid = 0x1 0x3 0x6 0x1
fs/cifs/asn1.c: OID len = 7 oid = 0x1 0x2 0x348 0xbb92
fs/cifs/asn1.c: OID len = 7 oid = 0x1 0x2 0x348 0x1bb92
fs/cifs/asn1.c: OID len = 8 oid = 0x1 0x2 0x348 0x1bb92
fs/cifs/asn1.c: OID len = 10 oid = 0x1 0x3 0x6 0x1
fs/cifs/cifssmb.c: negprot rc 0
fs/cifs/connect.c: Security Mode: 0xf Capabilities: 0x8001f3fc TimeAdjust: 28800
fs/cifs/sess.c: sess setup type 4
fs/cifs/sess.c: rawntlmssp session setup negotiate phase
fs/cifs/transport.c: For smb_command 115
fs/cifs/transport.c: Sending smb: smb_len=194
fs/cifs/connect.c: RFC1002 header 0x163
fs/cifs/misc.c: checkSMB Length: 0x167, smb_buf_length: 0x163
fs/cifs/transport.c: cifs_sync_mid_result: cmd=115 mid=2 state=4
fs/cifs/netmisc.c: Mapping smb error code 0xc0000016 to POSIX err -5
fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
fs/cifs/sess.c: rawntlmssp session setup challenge phase
fs/cifs/sess.c: UID = 8192
fs/cifs/sess.c: rawntlmssp session setup authenticate phase
fs/cifs/transport.c: For smb_command 115
fs/cifs/transport.c: Sending smb: smb_len=254
fs/cifs/connect.c: RFC1002 header 0xb3
fs/cifs/misc.c: checkSMB Length: 0xb7, smb_buf_length: 0xb3
fs/cifs/transport.c: cifs_sync_mid_result: cmd=115 mid=3 state=4
fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
fs/cifs/sess.c: bleft 135
fs/cifs/sess.c: serverOS=Windows Server 2016 Standard 14393
fs/cifs/sess.c: serverNOS=Windows Server 2016 Standard 6.3
fs/cifs/sess.c: CIFS session established successfully
fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses (xid = 1) rc = 0
fs/cifs/connect.c: CIFS VFS: in cifs_get_tcon as Xid: 2 with uid: 0
fs/cifs/transport.c: For smb_command 117
fs/cifs/transport.c: Sending smb: smb_len=90
fs/cifs/connect.c: RFC1002 header 0x23
fs/cifs/misc.c: checkSMB Length: 0x27, smb_buf_length: 0x23
fs/cifs/transport.c: cifs_sync_mid_result: cmd=117 mid=4 state=4
CIFS VFS: SMB signature verification returned error = -13
fs/cifs/netmisc.c: Mapping smb error code 0xc0000022 to POSIX err -13
fs/cifs/connect.c: CIFS VFS: leaving cifs_get_tcon (xid = 2) rc = -13
fs/cifs/connect.c: Tcon rc = -13
fs/cifs/connect.c: cifs_put_smb_ses: ses_count=1
fs/cifs/connect.c: CIFS VFS: in cifs_put_smb_ses as Xid: 3 with uid: 0
fs/cifs/cifssmb.c: In SMBLogoff for session disconnect
fs/cifs/transport.c: For smb_command 116
fs/cifs/transport.c: Sending smb: smb_len=39
fs/cifs/connect.c: RFC1002 header 0x27
fs/cifs/misc.c: checkSMB Length: 0x2b, smb_buf_length: 0x27
fs/cifs/transport.c: cifs_sync_mid_result: cmd=116 mid=5 state=4
CIFS VFS: SMB signature verification returned error = -13
SendRcvNoRsp flags 64 rc 0
fs/cifs/connect.c: CIFS VFS: leaving cifs_mount (xid = 0) rc = -13
CIFS VFS: cifs_mount failed w/return code = -13
mount error(13): Permission denied
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
++ sleep 2
++ sd
sysrq: SysRq : Power Off
++ set +x


Generating "/run/initramfs/rdsosreport.txt"
You might want to save "/run/initramfs/rdsosreport.txt" to a USB stick or /boot
after mounting them and attach it to a bug report.

To get more debug information in the report,
reboot with "rd.debug" added to the kernel command line.

Dropping to debug shell.

dracut:/# ACPI: Preparing to enter system sleep state S5
reboot: Power down

--=-=-=
Content-Type: application/vnd.tcpdump.pcap
Content-Disposition: attachment; filename=ml-guestfix_nouser.pcap
Content-Transfer-Encoding: base64

Cg0NClQAAABNPCsaAQAAAP//////////BAAtAFRTaGFyayAxLjEyLjEzIChHaXQgUmV2IFVua25v
d24gZnJvbSB1bmtub3duKQAAAAAAAABUAAAAAQAAACAAAAABAAAAAAAEAAkAAQAGAAAAAAAAACAA
AAAGAAAArAAAAAAAAACFQgUAYqZ+24sAAACLAAAAUlQA6PCaABY+dnDKCABFAAB9dnNAAEAGKtYK
oEIoCqBBypdWAb076qjhyWGmHIAYByE4GAAAAQEICv/+3pIfaB57AAAARf9TTUJyAAAAAAAByAAA
AAAAAAAAAAAAAAAAlgAAAAEAACIAAkxNMS4yWDAwMgACTEFOTUFOMi4xAAJOVCBMTSAwLjEyAACs
AAAABgAAADQBAAAAAAAAhUIFAJOnftsTAQAAEwEAAAAWPnZwylJUAOjwmggARQABBWnHQACABvb5
CqBBygqgQigBvZdWyWGmHDvqqSqAGCArjHIAAAEBCAofaB59//7ekgAAAM3/U01CcgAAAACAAcgA
AAAAAAAAAAAAAAAAAJYAAAABABECAA8yAAEABEEAAAAAAQAAAAAA/PMBgE8mMWgZS9IB4AEAiACg
0KhCWhh3TbyiOmkMP5cqYHYGBisGAQUFAqBsMGqgPDA6BgorBgEEAYI3AgIeBgkqhkiC9xIBAgIG
CSqGSIb3EgECAgYKKoZIhvcSAQICAwYKKwYBBAGCNwICCqMqMCigJhskbm90X2RlZmluZWRfaW5f
UkZDNDE3OEBwbGVhc2VfaWdub3JlADQBAAAGAAAAKAEAAAAAAACFQgUAqrl+2wgBAAAIAQAAUlQA
6PCaABY+dnDKCABFAAD6dnVAAEAGKlcKoEIoCqBBypdWAb076qkqyWGm7YAYB2TJwAAAAQEICv/+
3pMfaB59AAAAwv9TTUJzAAAAAAAF2AAAQlNSU1BZTAAAAAAAlgAAAAIADP8AAABUQDIAAQAAAAAA
IAAAAAAA3NAAgIcATlRMTVNTUAABAAAAFQII4AAAAAAAAAAAAAAAAAAAAAAATABpAG4AdQB4ACAA
dgBlAHIAcwBpAG8AbgAgADQALgA5AC4AMAAtAHIAYwA1ACsAAABDAEkARgBTACAAVgBGAFMAIABD
AGwAaQBlAG4AdAAgAGYAbwByACAATABpAG4AdQB4AAAAKAEAAAYAAADMAQAAAAAAAIVCBQCPun7b
qQEAAKkBAAAAFj52cMpSVADo8JoIAEUAAZtpyEAAgAb2YgqgQcoKoEIoAb2XVslhpu076qnwgBgg
KomkAAABAQgKH2gegv/+3pMAAAFj/1NNQnMWAADAgAXYAABCU1JTUFlMAAAAAACWAAAgAgAE/wBj
AQAAsAA4AU5UTE1TU1AAAgAAAAgACAA4AAAAFQKJ4pvSjRl7Me1QAAAAAAAAAABwAHAAQAAAAAoA
OTgAAAAPUwBVAFMARQACAAgAUwBVAFMARQABAAwAVwBTADIAMAAxADYABAAOAHMAdQBzAGUALgBk
AGUAAwAcAFcAUwAyADAAMQA2AC4AcwB1AHMAZQAuAGQAZQAFAA4AcwB1AHMAZQAuAGQAZQAHAAgA
TyYxaBlL0gEAAAAAAFcAaQBuAGQAbwB3AHMAIABTAGUAcgB2AGUAcgAgADIAMAAxADYAIABTAHQA
YQBuAGQAYQByAGQAIAAxADQAMwA5ADMAAABXAGkAbgBkAG8AdwBzACAAUwBlAHIAdgBlAHIAIAAy
ADAAMQA2ACAAUwB0AGEAbgBkAGEAcgBkACAANgAuADMAAAAAAMwBAAAGAAAAZAEAAAAAAACFQgUA
Ucl+20QBAABEAQAAUlQA6PCaABY+dnDKCABFAAE2dnZAAEAGKhoKoEIoCqBBypdWAb076qnwyWGo
VIAYB6flSAAAAQEICv/+3pQfaB6CAAAA/v9TTUJzAAAAAAAF2AAAQlNSU1BZTAAAAAAAlgAAIAMA
DP8AAABUQDIAAQAAAAAAXAAAAAAA3NAAgMMATlRMTVNTUAADAAAAAAAAAEAAAAAAAAAAQAAAAAgA
CABAAAAAAAAAAEgAAAAAAAAASgAAABAAEABMAAAAFQKI4FMAVQBTAEUAAAAAADqdnGwmwQeEWcdA
qU72cyYATABpAG4AdQB4ACAAdgBlAHIAcwBpAG8AbgAgADQALgA5AC4AMAAtAHIAYwA1ACsAAABD
AEkARgBTACAAVgBGAFMAIABDAGwAaQBlAG4AdAAgAGYAbwByACAATABpAG4AdQB4AAAAZAEAAAYA
AAAcAQAAAAAAAIVCBQB6y37b+QAAAPkAAAAAFj52cMpSVADo8JoIAEUAAOtpyUAAgAb3EQqgQcoK
oEIoAb2XVslhqFQ76qrygBggKcRoAAABAQgKH2gehv/+3pQAAACz/1NNQnMAAAAAgAXYAABCU1JT
UFlMAAAAAACWAAAgAwAE/wCzAAAAAACIAABXAGkAbgBkAG8AdwBzACAAUwBlAHIAdgBlAHIAIAAy
ADAAMQA2ACAAUwB0AGEAbgBkAGEAcgBkACAAMQA0ADMAOQAzAAAAVwBpAG4AZABvAHcAcwAgAFMA
ZQByAHYAZQByACAAMgAwADEANgAgAFMAdABhAG4AZABhAHIAZAAgADYALgAzAAAAAAAcAQAABgAA
AMAAAAAAAAAAhUIFAC7bftugAAAAoAAAAFJUAOjwmgAWPnZwyggARQAAknZ3QABABiq9CqBCKAqg
QcqXVgG9O+qq8slhqQuAGAfqOIwAAAEBCAr//t6VH2gehgAAAFr/U01CdQAAAAAABdAAAA4uz2eq
hh8UAAAAAJYAACAEAAT/AAAACAABAC8AAFwAXABXAFMAMgAwADEANgBcAGcAdQBlAHMAdABzAGgA
YQByAGUAAAA/Pz8/PwDAAAAABgAAAIwAAAAAAAAAhUIFALHbfttpAAAAaQAAAAAWPnZwylJUAOjw
mggARQAAW2nKQACABvegCqBBygqgQigBvZdWyWGpCzvqq1CAGCAp5HIAAAEBCAofaB6K//7elQAA
ACP/U01CdSIAAMCABdAAAA4uz2eqhh8UAAAAAJYAACAEAAAAAAAAAIwAAAAGAAAAkAAAAAAAAACF
QgUAR+p+220AAABtAAAAUlQA6PCaABY+dnDKCABFAABfdnhAAEAGKu8KoEIoCqBBypdWAb076qtQ
yWGpMoAYB+oVzgAAAQEICv/+3pYfaB6KAAAAJ/9TTUJ0AAAAAAAFAAAAwmyijT87qCIAAAAAlgAA
IAUAAv8AAAAAAAAAAJAAAAAGAAAAkAAAAAAAAACFQgUAtep+220AAABtAAAAABY+dnDKUlQA6PCa
CABFAABfactAAIAG95sKoEHKCqBCKAG9l1bJYakyO+qre4AYICn8uAAAAQEICh9oHo7//t6WAAAA
J/9TTUJ0AAAAAIAFAAAAwmyijT87qCIAAAAAlgAAIAUAAv8AJwAAAAAAAJAAAAA=
--=-=-=
Content-Type: text/plain
Content-Disposition: attachment; filename=ml-guestfix_user.out

!! BOOT SCRIPT !!
-------------------

++ echo 10.160.65.202 WS2016
++ modprobe e1000
++ modprobe cifs
++ mount -t debugfs none /sys/kernel/debug
++ echo 'create      cifs.spnego    * * /usr/sbin/cifs.upcall %k'
++ echo 'create      dns_resolver   * * /usr/sbin/cifs.upcall %k'
++ echo 'module cifs +p'
++ echo 'file fs/cifs/* +p'
++ echo 1
++ echo 8
++ echo 1
++ mkdir -p /mnt
++ echo 'echo 1 > /proc/sys/kernel/sysrq && echo o > /proc/sysrq-trigger'
random: fast init done
++ chmod a+x /bin/sd
++ mount -t cifs -vvv //WS2016/guestshare /mnt -o ip=10.160.65.202,guest,rw,user=abc
ip address 10.160.65.202 override specified
mount.cifs kernel mount options: ip=10.160.65.202,unc=\\WS2016\guestshare,user=abc,pass=********
fs/cifs/cifsfs.c: Devname: //WS2016/guestshare flags: 0
address conversion returned 1 for 10.160.65.202
fs/cifs/connect.c: Username: abc
fs/cifs/connect.c: file mode: 0x1ed  dir mode: 0x1ed
fs/cifs/connect.c: CIFS VFS: in cifs_mount as Xid: 0 with uid: 0
fs/cifs/connect.c: UNC: \\WS2016\guestshare
fs/cifs/connect.c: Socket created
fs/cifs/connect.c: sndbuf 16384 rcvbuf 87380 rcvtimeo 0x6d6
fs/cifs/connect.c: CIFS VFS: in cifs_get_smb_ses as Xid: 1 with uid: 0
fs/cifs/connect.c: Existing smb sess not found
fs/cifs/cifssmb.c: Requesting extended security.fs/cifs/transport.c: For smb_command 114
fs/cifs/transport.c: Sending smb: smb_len=69
fs/cifs/connect.c: Demultiplex PID: 153
fs/cifs/connect.c: RFC1002 header 0xcd
fs/cifs/misc.c: checkSMB Length: 0xd1, smb_buf_length: 0xcd
fs/cifs/transport.c: cifs_sync_mid_result: cmd=114 mid=1 state=4
fs/cifs/cifssmb.c: Dialect: 2
Max buf = 16644
fs/cifs/asn1.c: OID len = 10 oid = 0x1 0x3 0x6 0x1
fs/cifs/asn1.c: OID len = 7 oid = 0x1 0x2 0x348 0xbb92
fs/cifs/asn1.c: OID len = 7 oid = 0x1 0x2 0x348 0x1bb92
fs/cifs/asn1.c: OID len = 8 oid = 0x1 0x2 0x348 0x1bb92
fs/cifs/asn1.c: OID len = 10 oid = 0x1 0x3 0x6 0x1
fs/cifs/cifssmb.c: negprot rc 0
fs/cifs/connect.c: Security Mode: 0xf Capabilities: 0x8001f3fc TimeAdjust: 28800
fs/cifs/sess.c: sess setup type 4
fs/cifs/sess.c: rawntlmssp session setup negotiate phase
fs/cifs/transport.c: For smb_command 115
fs/cifs/transport.c: Sending smb: smb_len=194
fs/cifs/connect.c: RFC1002 header 0x163
fs/cifs/misc.c: checkSMB Length: 0x167, smb_buf_length: 0x163
fs/cifs/transport.c: cifs_sync_mid_result: cmd=115 mid=2 state=4
fs/cifs/netmisc.c: Mapping smb error code 0xc0000016 to POSIX err -5
fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
fs/cifs/sess.c: rawntlmssp session setup challenge phase
fs/cifs/sess.c: UID = 8192
fs/cifs/sess.c: rawntlmssp session setup authenticate phase
fs/cifs/transport.c: For smb_command 115
fs/cifs/transport.c: Sending smb: smb_len=414
fs/cifs/connect.c: RFC1002 header 0x23
fs/cifs/misc.c: checkSMB Length: 0x27, smb_buf_length: 0x23
fs/cifs/transport.c: cifs_sync_mid_result: cmd=115 mid=3 state=4
Status code returned 0xc000006d NT_STATUS_LOGON_FAILURE
fs/cifs/netmisc.c: Mapping smb error code 0xc000006d to POSIX err -13
fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
CIFS VFS: Send error in SessSetup = -13
fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses (xid = 1) rc = -13
fs/cifs/connect.c: CIFS VFS: leaving cifs_mount (xid = 0) rc = -13
CIFS VFS: cifs_mount failed w/return code = -13
mount error(13): Permission denied
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
++ sleep 2
++ sd
sysrq: SysRq : Power Off
++ set +x


Generating "/run/initramfs/rdsosreport.txt"
You might want to save "/run/initramfs/rdsosreport.txt" to a USB stick or /boot
after mounting them and attach it to a bug report.

To get more debug information in the report,
reboot with "rd.debug" added to the kernel command line.

Dropping to debug shell.

dracut:/# ACPI: Preparing to enter system sleep state S5
reboot: Power down

--=-=-=
Content-Type: application/vnd.tcpdump.pcap
Content-Disposition: attachment; filename=ml-guestfix_user.pcap
Content-Transfer-Encoding: base64

Cg0NClQAAABNPCsaAQAAAP//////////BAAtAFRTaGFyayAxLjEyLjEzIChHaXQgUmV2IFVua25v
d24gZnJvbSB1bmtub3duKQAAAAAAAABUAAAAAQAAACAAAAABAAAAAAAEAAkAAQAGAAAAAAAAACAA
AAAGAAAArAAAAAAAAACFQgUAch0S3IsAAACLAAAAUlQA6PCaABY+H0+dCABFAAB9nZNAAEAGBQ8K
oEDPCqBByoO2Ab0Ca0Mcpaw0ioAYByFb5QAAAQEICv/+3oofaEQ7AAAARf9TTUJyAAAAAAAByAAA
AAAAAAAAAAAAAAAAlgAAAAEAACIAAkxNMS4yWDAwMgACTEFOTUFOMi4xAAJOVCBMTSAwLjEyAACs
AAAABgAAADQBAAAAAAAAhUIFANMeEtwTAQAAEwEAAAAWPh9PnVJUAOjwmggARQABBUtcQACABha+
CqBBygqgQM8BvYO2paw0igJrQ2WAGCArFMsAAAEBCAofaEQ9//7eigAAAM3/U01CcgAAAACAAcgA
AAAAAAAAAAAAAAAAAJYAAAABABECAA8yAAEABEEAAAAAAQAAAAAA/PMBgCmV8m0ZS9IB4AEAiACg
0KhCWhh3TbyiOmkMP5cqYHYGBisGAQUFAqBsMGqgPDA6BgorBgEEAYI3AgIeBgkqhkiC9xIBAgIG
CSqGSIb3EgECAgYKKoZIhvcSAQICAwYKKwYBBAGCNwICCqMqMCigJhskbm90X2RlZmluZWRfaW5f
UkZDNDE3OEBwbGVhc2VfaWdub3JlADQBAAAGAAAAKAEAAAAAAACFQgUAcDAS3AgBAAAIAQAAUlQA
6PCaABY+H0+dCABFAAD6nZVAAEAGBJAKoEDPCqBByoO2Ab0Ca0Nlpaw1W4AYB2TtjAAAAQEICv/+
3owfaEQ9AAAAwv9TTUJzAAAAAAAF2AAAQlNSU1BZTAAAAAAAlgAAAAIADP8AAABUQDIAAQAAAAAA
IAAAAAAA3NAAgIcATlRMTVNTUAABAAAAFQII4AAAAAAAAAAAAAAAAAAAAAAATABpAG4AdQB4ACAA
dgBlAHIAcwBpAG8AbgAgADQALgA5AC4AMAAtAHIAYwA1ACsAAABDAEkARgBTACAAVgBGAFMAIABD
AGwAaQBlAG4AdAAgAGYAbwByACAATABpAG4AdQB4AAAAKAEAAAYAAADMAQAAAAAAAIVCBQA9MRLc
qQEAAKkBAAAAFj4fT51SVADo8JoIAEUAAZtLXUAAgAYWJwqgQcoKoEDPAb2DtqWsNVsCa0QrgBgg
KkYjAAABAQgKH2hEQv/+3owAAAFj/1NNQnMWAADAgAXYAABCU1JTUFlMAAAAAACWAAAgAgAE/wBj
AQAAsAA4AU5UTE1TU1AAAgAAAAgACAA4AAAAFQKJ4nLmxrK9QwEkAAAAAAAAAABwAHAAQAAAAAoA
OTgAAAAPUwBVAFMARQACAAgAUwBVAFMARQABAAwAVwBTADIAMAAxADYABAAOAHMAdQBzAGUALgBk
AGUAAwAcAFcAUwAyADAAMQA2AC4AcwB1AHMAZQAuAGQAZQAFAA4AcwB1AHMAZQAuAGQAZQAHAAgA
cvX0bRlL0gEAAAAAAFcAaQBuAGQAbwB3AHMAIABTAGUAcgB2AGUAcgAgADIAMAAxADYAIABTAHQA
YQBuAGQAYQByAGQAIAAxADQAMwA5ADMAAABXAGkAbgBkAG8AdwBzACAAUwBlAHIAdgBlAHIAIAAy
ADAAMQA2ACAAUwB0AGEAbgBkAGEAcgBkACAANgAuADMAAAAAAMwBAAAGAAAABAIAAAAAAACFQgUA
wz8S3OQBAADkAQAAUlQA6PCaABY+H0+dCABFAAHWnZZAAEAGA7MKoEDPCqBByoO2Ab0Ca0Qrpaw2
woAYB6fPqwAAAQEICv/+3o0faERCAAABnv9TTUJzAAAAAAAF2AAAQlNSU1BZTAAAAAAAlgAAIAMA
DP8AAABUQDIAAQAAAAAA/AAAAAAA3NAAgGMBTlRMTVNTUAADAAAAAAAAAEAAAACcAJwAQAAAAAgA
CADcAAAABgAGAOQAAAAAAAAA6gAAABAAEADsAAAAFQKI4LP2+BZt+ci5wXPtl2Oqh98BAQAAAAAA
AHL19G0ZS9IBxVJycgP4QJkAAAAAAgAIAFMAVQBTAEUAAQAMAFcAUwAyADAAMQA2AAQADgBzAHUA
cwBlAC4AZABlAAMAHABXAFMAMgAwADEANgAuAHMAdQBzAGUALgBkAGUABQAOAHMAdQBzAGUALgBk
AGUABwAIAHL19G0ZS9IBAAAAAFMAVQBTAEUAYQBiAGMAAAByu2WbZO1yG05k7K9y7YiRAEwAaQBu
AHUAeAAgAHYAZQByAHMAaQBvAG4AIAA0AC4AOQAuADAALQByAGMANQArAAAAQwBJAEYAUwAgAFYA
RgBTACAAQwBsAGkAZQBuAHQAIABmAG8AcgAgAEwAaQBuAHUAeAAAAAQCAAAGAAAAjAAAAAAAAACF
QgUA3UES3GkAAABpAAAAABY+H0+dUlQA6PCaCABFAABbS15AAIAGF2YKoEHKCqBAzwG9g7alrDbC
AmtFzYAYICmBlgAAAQEICh9oREb//t6NAAAAI/9TTUJzbQAAwIAF2AAAQlNSU1BZTAAAAAAAlgAA
IAMAAAAAAAAAjAAAAA==
--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton, HRB 21284 (AG N=
=C3=BCrnberg)

--=-=-=--
