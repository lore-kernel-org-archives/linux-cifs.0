From: Shinnosuke Yagi <yagi.shinnosuke-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
Subject: Re: Source code of SMB2 Kernel module
Date: Fri, 12 Nov 2010 14:16:53 +0900
Message-ID: <4CDCCDC5.6020603@nttcom.co.jp>
References: <4CC65859.7040100@nttcom.co.jp>	<4CC6642F.2040401@suse.de>	<4CCA6FD3.4060907@nttcom.co.jp>	<4CCA7177.40303@suse.de>	<4CCF5DF8.9030809@nttcom.co.jp>	<4CD12521.2020708@suse.de>	<4CD35A27.4050605@nttcom.co.jp>	<AANLkTinm718oZX2Qc4++W_CYkv0+RZRwr09Uzu4zcDn0@mail.gmail.com>	<4CD76751.8010700@nttcom.co.jp>	<AANLkTimx3ukvAjmuf5KQ3dSLVhpaF51pXcOfS1E_iFhY@mail.gmail.com>	<4CD784AB.3040805@suse.de>	<4CD8C4E6.5080603@nttcom.co.jp> <AANLkTikeNCCoMTsnaMMs6jqivgbke9hTUx_25hosM=-9@mail.gmail.com> <4CDA4E5C.90004@nttcom.co.jp> <4CDA5225.8000309@suse.de> <4CDA5955.50409@nttcom.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CDA5955.50409-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>



(2010/11/10 17:35), Shinnosuke Yagi wrote:
 >
 > I patched and tried to mount again.
 >
 > I mount successfully by smb2.
 > However, Kernel clashed when I accessed to mounted FS.
 >

I got following messages through netconsole
  when Kernel Oops was occuerd.

Kernel Opps occuerd when I execute
  ls /mount/point

Client is Ubuntu 10.04 and cifs-util 4.7
Server is Ubuntu 10.04 and Samba 3.5.6


===============================================
BUG: unable to handle kernel
paging request at 75636573 IP:
[<c0501b08>] generic_getxattr+0x2c/0x6a
*pde = 00000000

Oops: 0000 [#1] SMP
last sysfs file: 
/sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/uevent
Modules linked in:
nls_utf8
smb2
ppdev
rpcsec_gss_krb5
auth_rpcgss
sunrpc
snd_hda_codec_realtek
netconsole
snd_hda_intel
tun
i915
configfs
snd_hda_codec
snd_hwdep
bridge
snd_pcm_oss
snd_mixer_oss
snd_pcm
snd_seq_dummy
snd_seq_oss
snd_seq_midi
drm_kms_helper
stp
llc
lp
snd_rawmidi
drm
snd_seq_midi_event
snd_seq
snd_timer
snd_seq_device
snd
tpm_infineon
i2c_algo_bit
i2c_core
hp_wmi
serio_raw
video
rfkill
soundcore
parport
wmi
output
snd_page_alloc
e1000e
nbd
ata_generic
pata_acpi


Pid: 1842, comm: ls Tainted: GW 2.6.36-rc4+ #1 3647h/HP Compaq 8000 
Elite CMT PC
EIP: 0060:[<c0501b08>] EFLAGS: 00010282 CPU: 0
EIP is at generic_getxattr+0x2c/0x6a
EAX: edef9088 EBX: 75636573 ECX: 0000006f EDX: ee399e80
ESI: ee399e80 EDI: 00000000 EBP: ee399e50 ESP: ee399e38
DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process ls (pid: 1842, ti=ee398000 task=ee0e6500 task.ti=ee398000)
Stack:
fbf99dbc
fbf9a6fc
75636573
ee399e80
c0501adc
edef9088
ee399e6c
c050210a


00000000
00000000
00000017
00000000
00000000
ee399f90
c050250b
00000000


00000000
edef9088
74737973
702e6d65
7869736f
6c63615f
6363615f
00737365

Call Trace:
[<c0501adc>] ? generic_getxattr+0x0/0x6a
[<c050210a>] ? vfs_getxattr+0x79/0x82
[<c050250b>] ? getxattr+0x8f/0xea
[<c04f41df>] ? path_to_nameidata+0x11/0x2a
[<c04f5ec5>] ? link_path_walk+0x353/0x358
[<c04f4127>] ? mntput+0x13/0x15
[<c04f4127>] ? mntput+0x13/0x15
[<c04f58e3>] ? putname+0x25/0x2e
[<c04f68e7>] ? user_path_at+0x42/0x5f
[<c04f064c>] ? sys_lstat64+0x22/0x28
[<c05e0dfc>] ? _atomic_dec_and_lock+0x2c/0x44
[<c0502626>] ? sys_getxattr+0x36/0x49
[<c042709f>] ? sysenter_do_call+0x12/0x28
Code: 89 e5 57 89 cf 56 89 d6 53 83 ec 0c 8b 50 54 85 f6 8b 52 6c 75 2b 
eb 35 8b 13 89 5d e8 89 55 f0 89 f2 eb 04 ff 45 f0 42 8b 5d f0 
unparseable log message: "<8a> "0b 84 c9 74 06 38 0a 74 ef eb 07 85 d2 
8b 5d e8 75 1c 8b 55
EIP: [<c0501b08>]
generic_getxattr+0x2c/0x6a
SS:ESP 0068:ee399e38
CR2: 0000000075636573
---[ end trace b00826b595f2760c ]---
[drm:drm_mode_getfb] *ERROR* invalid framebuffer id
===========================================================


(2010/11/10 17:35), Shinnosuke Yagi wrote:
>
> I patched and tried to mount again.
>
> I mount successfully by smb2.
> However, Kernel clashed when I accessed to mounted FS.
>
> I couldn't got any logs, because I did not set kdump.
>
> I will try to get a clashed kernel dump.
>
> Please wait.
>
>
> Thanks.
>
>
> (2010/11/10 17:04), Suresh Jayaraman wrote:
>> On 11/10/2010 01:18 PM, Shinnosuke Yagi wrote:
>>>
>>> I added some logging messages.
>>>
>>> # git diff fs/smb2/smb2fs.c
>>> diff --git a/fs/smb2/smb2fs.c b/fs/smb2/smb2fs.c
>>> index aa550a3..52c9f35 100644
>>> --- a/fs/smb2/smb2fs.c
>>> +++ b/fs/smb2/smb2fs.c
>>> @@ -57,7 +57,7 @@ static struct quotactl_ops smb2_quotactl_ops;
>>>
>>> /* Definitions of various global variables follow */
>>>
>>> -int smb2FYI;
>>> +int smb2FYI = 1;
>>> int smb2ERROR = 1;
>>> int trace_SMB2;
>>>
>>> I got following logs on dmesg.
>>> ====================================================
>>> FS-Cache: Netfs 'smb2' registered for caching
>>> fs/smb2/smb2fs.c: SMB2_max_buf_size 0x4000
>>> fs/smb2/smb2fs.c: smb2_init_request_bufs 0
>>> fs/smb2/smb2fs.c: register_filesystem 0
>>> fs/smb2/smb2fs.c: register_key_type -17
>>
>> -17 is -EEXIST which means ket type with the name is already present.
>> The below patch should fix the problem I think. Could you try and
>> report back?
>>
>>
>> From: Suresh Jayaraman<sjayaraman-l3A5Bk7waGM@public.gmane.org>
>> Subject: [PATCH] smb2: rename smb2 spnego key type
>>
>> .. to avoid key registration failure. register_key_type() doesn't
>> allow key
>> types with same names.
>>
>> Reported-by: Shinnosuke Yagi<yagi.shinnosuke-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
>> Signed-off-by: Suresh Jayaraman<sjayaraman-l3A5Bk7waGM@public.gmane.org>
>> ---
>> fs/smb2/smb2_spnego.c | 2 +-
>> 1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/smb2/smb2_spnego.c b/fs/smb2/smb2_spnego.c
>> index 6551002..24df95a 100644
>> --- a/fs/smb2/smb2_spnego.c
>> +++ b/fs/smb2/smb2_spnego.c
>> @@ -61,7 +61,7 @@ smb2_spnego_key_destroy(struct key *key)
>> * keytype for SMB2 spnego keys
>> */
>> struct key_type smb2_spnego_key_type = {
>> - .name = "cifs.spnego",
>> + .name = "smb2.spnego",
>> .instantiate = smb2_spnego_key_instantiate,
>> .match = user_match,
>> .destroy = smb2_spnego_key_destroy,
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>
>>
>>
