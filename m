From: starlight@binnacle.cx
Subject: Re: question about CIFS client glitches
Date: Fri, 17 Sep 2010 19:38:21 -0400
Message-ID: <6.2.5.6.2.20100917193123.056b6f78@binnacle.cx>
References: <6.2.5.6.2.20100916171408.03a0fcd8@flumedata.com>
	<AANLkTimDWbZF=DkmVLw96V3nZGggFfNm0Zv3FxfFX1BE@mail.gmail.com>
	<6.2.5.6.2.20100916195402.0573dcc0@binnacle.cx>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="=====================_608419249==_"
Cc: samba@lists.samba.org, linux-cifs@vger.kernel.org
To: Steve French <smfrench@gmail.com>
Return-path: <samba-bounces@lists.samba.org>
In-Reply-To: <6.2.5.6.2.20100916195402.0573dcc0@binnacle.cx>
References: <6.2.5.6.2.20100916171408.03a0fcd8@flumedata.com>
	<AANLkTimDWbZF=DkmVLw96V3nZGggFfNm0Zv3FxfFX1BE@mail.gmail.com>
	<6.2.5.6.2.20100916195402.0573dcc0@binnacle.cx>
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

--=====================_608419249==_
Content-Type: text/plain; charset="us-ascii"

At 05:50 PM 9/16/2010 -0500, Steve French wrote:
>On Thu, Sep 16, 2010 at 4:39 PM,  <starlight@binnacle.cx> wrote:
>> Trying out a CIFS mount of a W2K8 x64 file system from CentOS
>> 5.5 and running into problems, and trying to figure out how to
>> proceed.
...
>
>This is quite old kernel, but perhaps it was updated to include more
>recent fixes - can you view the version information on the file, ie
>the cifs.ko module (you can do this by running modinfo on cifs.ko)


Tried the RHEL6 beta 2 and it behaves the same as RHEL 5.5.
'modinfo' output for both attached.  'cifs.ko' versions are
1.60RH and 1.63.

In both versions it seems like hard-links work and symbolic
links fail with

   ln: creating symbolic link `zzzz': Operation not supported

And it appears that a 'pax -r' extraction followed by 'rm' for
selected files has some difficulty with CIFS 1.6x rendered
hard link in the mix.

I'm probably giving up on the idea for now, but thanks
for your help.
--=====================_608419249==_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment; filename="rhel5_cifs_info.txt"

filename:       /lib/modules/2.6.18-194.11.3.el5/kernel/fs/cifs/cifs.ko
version:        1.60RH
description:    VFS to access servers complying with the SNIA CIFS Specification e.g. Samba and Windows
license:        GPL
author:         Steve French <sfrench@us.ibm.com>
srcversion:     20DD0BE6A19ED378F7D2C33
depends:        
vermagic:       2.6.18-194.11.3.el5 SMP mod_unload gcc-4.1
parm:           CIFSMaxBufSize:Network buffer size (not including header). Default: 16384 Range: 8192 to 130048 (int)
parm:           cifs_min_rcv:Network buffers in pool. Default: 4 Range: 1 to 64 (int)
parm:           cifs_min_small:Small network buffers in pool. Default: 30 Range: 2 to 256 (int)
parm:           cifs_max_pending:Simultaneous requests to server. Default: 50 Range: 2 to 256 (int)
module_sig:	883f3504c7c19149bce751f598f18801122e6109d17621f882165893a79cb97d25e6869960ede5e09a2fef8da5b3ab56d24567891cdc21676f35835

--=====================_608419249==_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment; filename="rhel6_cifs_info.txt"

filename:       /lib/modules/2.6.32-44.2.el6.x86_64/kernel/fs/cifs/cifs.ko
version:        1.63
description:    VFS to access servers complying with the SNIA CIFS Specification e.g. Samba and Windows
license:        GPL
author:         Steve French <sfrench@us.ibm.com>
srcversion:     91CD42CFC5D35D5285E34E1
depends:        
vermagic:       2.6.32-44.2.el6.x86_64 SMP mod_unload modversions 
parm:           CIFSMaxBufSize:Network buffer size (not including header). Default: 16384 Range: 8192 to 130048 (int)
parm:           cifs_min_rcv:Network buffers in pool. Default: 4 Range: 1 to 64 (int)
parm:           cifs_min_small:Small network buffers in pool. Default: 30 Range: 2 to 256 (int)
parm:           cifs_max_pending:Simultaneous requests to server. Default: 50 Range: 2 to 256 (int)

--=====================_608419249==_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-- 
To unsubscribe from this list go to the following URL and read the
instructions:  https://lists.samba.org/mailman/options/samba
--=====================_608419249==_--
