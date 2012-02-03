From: Jakov Sosic <jakov.sosic@srce.hr>
Subject: Re: Samba 3.5 & CIFS mounts - long standing issue...
Date: Fri, 03 Feb 2012 16:09:26 +0100
Message-ID: <4F2BF8A6.7060603@srce.hr>
References: <4F2BCF5E.8090109@srce.hr>
	<CADT32eJPbBo8m0k-L-eZaKgcfOa2jibd6ggz82OC47MEJ82T0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Cc: samba@lists.samba.org, linux-cifs <linux-cifs@vger.kernel.org>
To: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Return-path: <samba-bounces@lists.samba.org>
In-Reply-To: <CADT32eJPbBo8m0k-L-eZaKgcfOa2jibd6ggz82OC47MEJ82T0Q@mail.gmail.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba>,
	<mailto:samba-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba>
List-Post: <mailto:samba@lists.samba.org>
List-Help: <mailto:samba-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba>,
	<mailto:samba-request@lists.samba.org?subject=subscribe>
Sender: samba-bounces@lists.samba.org
Errors-To: samba-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

On 02/03/2012 03:44 PM, Shirish Pargaonkar wrote:
> On Fri, Feb 3, 2012 at 6:13 AM, Jakov Sosic<jakov.sosic@srce.hr>  wrote:
>> Hi.
>>
>> I can see that this is a long long standing issue... Apparently things
>> changed in Windows 2008 R2, and after upgrade of domain from R1 to R2 cifs
>> mounts don't work anymore between Linux servers. Windows can see Samba
>> shares and mount them, but CIFS on another Linux box cannot...
>>
>> Here is a thread with explanation in lenght:
>> http://ubuntuforums.org/showthread.php?t=1178484
>>
>> I get the exact same logs and errors... I've tested with smbclient and
>> everything works but with CIFS - no way :(
>>
>> Has anybody succeded in solving this one?
>>
>>
>> Mount with CIFS:
>> #  mount -t cifs //server/share /mnt -o
>> username=jakov.sosic,password=*******,domain=mydomain -v
>>
>> mount.cifs kernel mount options:
>> unc=//server\share,ver=1,username=jakov.sosic,domain=mydomain,ip=xxx.xxx.xxx.xxx,pass=********
>> mount error(13): Permission denied
>> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
>>
>>
>> Login with smbclient:
>>
>> # smbclient -U jakov.sosic //server/share
>> Enter Administrator's password:
>> Domain=[MYDOMAIN] OS=[Unix] Server=[Samba 3.5.4-0.83.el5_7.2]
>> smb: \>
>>
>>
>> I've tried adding various mount parameters like sec=ntlmv2,
>> credentials=/path/to/file, but every attempt fails.
>>
>> Any ideas?!?!!
>>
>>
>> Samba is version 3.5.4 on CentOS 5.7 on both Linux machines.

Hm, it seems to be working now...


I've added the following to smb.conf on the server:

"map untrusted to domain = yes"

restarted samba, tried - it wouldn't work. Removed that line, restarted 
again, tried again, now it works...

Also, domain should be noted in lowercase.

Don't know what fixed it ...


Also if you have hidden share (with $ at the end of the name), you 
shouldn't escape it in /etc/fstab or in automount maps.




PS:

# modinfo cifs
filename:       /lib/modules/2.6.18-274.7.1.el5/kernel/fs/cifs/cifs.ko
version:        1.60RH
description:    VFS to access servers complying with the SNIA CIFS 
Specification e.g. Samba and Windows
license:        GPL
author:         Steve French <sfrench@us.ibm.com>
srcversion:     CB01A53173C481FE5E6FF69
depends:
vermagic:       2.6.18-274.7.1.el5 SMP mod_unload gcc-4.1
parm:           CIFSMaxBufSize:Network buffer size (not including 
header). Default: 16384 Range: 8192 to 130048 (int)
parm:           cifs_min_rcv:Network buffers in pool. Default: 4 Range: 
1 to 64 (int)
parm:           cifs_min_small:Small network buffers in pool. Default: 
30 Range: 2 to 256 (int)
parm:           cifs_max_pending:Simultaneous requests to server. 
Default: 50 Range: 2 to 256 (int)
module_sig: 
883f3504ea08a83e35359b9fcadd15112127009f5cd5f84520a7fe8b58314afabd51ca0b12cf0760a0cdb12f7ec2dd33a5f842dcc57d643245b5f434



-- 
Jakov Sosic
www.srce.unizg.hr
-- 
To unsubscribe from this list go to the following URL and read the
instructions:  https://lists.samba.org/mailman/options/samba
