From: Germano Percossi <germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: Re: Unable to mount windows share as administrator
Date: Tue, 4 Apr 2017 09:52:08 +0100
Message-ID: <d280afda-7acd-9f18-1c63-f9a2a886d1f7@citrix.com>
References: <CAJvXCJfBq=iLK=pPXuwQN1fZ4exVkrp2QP5cywWhygpMoKZPLA@mail.gmail.com>
 <af6f37b9-fb85-da5d-7867-8aaec8f05f7a@citrix.com>
 <CAJvXCJdEbWByRsViSTj1RajM1PSVBUqdq4EzQZW=uH5Bz6yB0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jon Scott <jonzanscott-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJvXCJdEbWByRsViSTj1RajM1PSVBUqdq4EzQZW=uH5Bz6yB0w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 04/04/2017 02:22 AM, Jon Scott wrote:
> 
> and from the unsuccessful one:
> 
[cut]
> AndX Request, NTLMSSP_NEGOTIATE
>  29 3.002076572  192.168.1.2 -> 192.168.1.4  SMB 321 Session Setup
> AndX Response, NTLMSSP_CHALLENGE, Error:
> STATUS_MORE_PROCESSING_REQUIRED
>  30 3.002505936  192.168.1.4 -> 192.168.1.2  SMB 450 Session Setup
> AndX Request, NTLMSSP_AUTH, User: RONE\root
>  31 3.003142299  192.168.1.2 -> 192.168.1.4  SMB 105 Session Setup
> AndX Response, Error: STATUS_LOGON_FAILURE

Does Windows understand "root" as administrator?

> 
> On Mon, Apr 3, 2017 at 6:09 AM, Germano Percossi
> <germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org> wrote:
>> Hi,
>>
>> Before the right guys would answer more appropriately than me:
>>
>> 1) are the 2 users credentials stored in the same domain?
>> 2) what is the difference in the packet trace between the successful
>>    one and the failing one?
>> 3) what does the kern.log (or dmesg) says when the cifs module verbosity
>>    is increased?
>>
>> Cheers,
>> Germano
>>
>> On 04/02/2017 11:39 PM, Jon Scott wrote:
>>> I'm able to mount a share from Windows 10 without problems if my
>>> .smbcredentials file contains a username and password of a regular
>>> user on the Windows system.  However, if I change the credentials to
>>> an administrator on the Windows system, I get:
>>>
>>> mount error(13): Permission denied
>>> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
>>>
>>> Here's the relevant /etc/fstab entry:
>>> //RONE/Users/fran /rone_users cifs
>>> credentials=/home/jon/.smbcredentials,ro,iocharset=utf8 0 0
>>>
>>> 4.4.0-71-generic
>>> mount.cifs version: 6.4
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
