From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: Source code of SMB2 Kernel module
Date: Mon, 08 Nov 2010 10:33:39 +0530
Message-ID: <4CD784AB.3040805@suse.de>
References: <4CC65859.7040100@nttcom.co.jp>	<4CC6642F.2040401@suse.de>	<4CCA6FD3.4060907@nttcom.co.jp>	<4CCA7177.40303@suse.de>	<4CCF5DF8.9030809@nttcom.co.jp>	<4CD12521.2020708@suse.de>	<4CD35A27.4050605@nttcom.co.jp>	<AANLkTinm718oZX2Qc4++W_CYkv0+RZRwr09Uzu4zcDn0@mail.gmail.com>	<4CD76751.8010700@nttcom.co.jp> <AANLkTimx3ukvAjmuf5KQ3dSLVhpaF51pXcOfS1E_iFhY@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shinnosuke Yagi <yagi.shinnosuke-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimx3ukvAjmuf5KQ3dSLVhpaF51pXcOfS1E_iFhY-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 11/08/2010 10:23 AM, Steve French wrote:
> On Sun, Nov 7, 2010 at 8:58 PM, Shinnosuke Yagi
> <yagi.shinnosuke-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org> wrote:
>>
>>>
>>> try a modprobe smb2 or insmod smb2.ko
>>>
>>
>> I tried, but nothing changed.
>>
>> =================================================================
>> # modprobe -v smb2
>> insmod /lib/modules/2.6.36-rc4+/kernel/fs/smb2/smb2.ko
>> # mount -t smb2 //server/share /mnt/point -o user=xxxx
>> Password:
>> mount error: smb2 filesystem not supported by the system
>> mount error(19): No such device
>> Refer to the mount.smb2(8) manual page (e.g. man mount.smb2)
>> typescript (END)
>> =================================================================
>>
>> I got the same result when I tried with kernel bulit-in parameters
>> ( CONFIG_SMB2_FS=y ).
>>
>> Do I have to install other modules?
> 
> Yes - you need fscache, I turned the equivalent of Suresh's cifs
> fscache (for smb2) on by default.
> 
> "modprobe fscache"
> 

I guess absence of fscache would result in a different error than this
(perhaps invalid module format or something) and you won't be able to
successfully load smb2 module itself..

But, you could verify whether the smb2 module is loaded successfully by
doing
  lsmod | grep smb2

Also check dmesg output for possible errors..



-- 
Suresh Jayaraman
