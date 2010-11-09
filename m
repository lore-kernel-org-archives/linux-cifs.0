From: Shinnosuke Yagi <yagi.shinnosuke-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
Subject: Re: Source code of SMB2 Kernel module
Date: Tue, 09 Nov 2010 12:49:58 +0900
Message-ID: <4CD8C4E6.5080603@nttcom.co.jp>
References: <4CC65859.7040100@nttcom.co.jp>	<4CC6642F.2040401@suse.de>	<4CCA6FD3.4060907@nttcom.co.jp>	<4CCA7177.40303@suse.de>	<4CCF5DF8.9030809@nttcom.co.jp>	<4CD12521.2020708@suse.de>	<4CD35A27.4050605@nttcom.co.jp>	<AANLkTinm718oZX2Qc4++W_CYkv0+RZRwr09Uzu4zcDn0@mail.gmail.com>	<4CD76751.8010700@nttcom.co.jp> <AANLkTimx3ukvAjmuf5KQ3dSLVhpaF51pXcOfS1E_iFhY@mail.gmail.com> <4CD784AB.3040805@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CD784AB.3040805-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Thank you, Suresh and Steve.


Fscache was loaded, but smb2 module was not loaded successfully.
Nothing was displayed when I did
>    lsmod | grep smb2

 From Dmesg, following messages were displayed.
====================================================
FS-Cache: Netfs 'smb2' registered for caching
FS-Cache: Netfs 'smb2' unregistered from caching
====================================================

Does this means FS-Cache on this kernel doesn't support smb2?



>
> I guess absence of fscache would result in a different error than this
> (perhaps invalid module format or something) and you won't be able to
> successfully load smb2 module itself..
>
> But, you could verify whether the smb2 module is loaded successfully by
> doing
>    lsmod | grep smb2
>
> Also check dmesg output for possible errors..
>
>
>
