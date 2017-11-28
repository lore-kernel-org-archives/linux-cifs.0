From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: SMB 2 & later leaves files in bad inconsistent state
Date: Tue, 28 Nov 2017 14:06:29 +0100
Message-ID: <87induft7u.fsf@suse.com>
References: <CALQF7ZyjHDqW+8WiA=Xo3-he6jdVtse+ULme2zj9CJm8G5jX_g@mail.gmail.com> <CALQF7Zwk7HGGkU0MXLGrSrA7JHwQP5m1e3U2J6_5O0A7+uJfzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
To: Yale Zhang <yzhang1985-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALQF7Zwk7HGGkU0MXLGrSrA7JHwQP5m1e3U2J6_5O0A7+uJfzw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Yale Zhang <yzhang1985-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
> On Sat, Nov 18, 2017 at 7:55 PM, Yale Zhang <yzhang1985-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> I'm having a very annoying problem when compiling my code on GNU/Linux
>> that's mounted from a Windows 10 desktop.
>>
>> When I press Ctrl-C to interrupt make, sometimes it leaves the object
>> or executable files in a bad inconsistent state. The file cannot be
>> deleted on Linux or Windows until you reboot Windows, a huge
>> productivity killer.
>>
>> If you try to see the file's owner, it's undefined, which explains why
>> it can't be deleted. See 1st screenshot.
>>
>>
>> I used lsof to check if anyone is holding on to that file, but no one.
>> I also used ProcessExplorer to check on the server side and found the
>> "system" process holding it. For some reason, I can't forcefully close
>> that file. See 2nd screenshot.
>>
>> So is this a problem with the SMB client or server? Any work arounds
>> besides switching back to CIFS?

It could be some sort of buggy lock held by the Windows kernel or just
something keeping an open handle on it without the FILE_SHARE_DELETE
flag. Does it also happen against a samba server?

Best way to look into this would be to come up with a small reproducible
scenario and capture a network trace of it.

Given your description I came up with this but to be close to your
actual problem you should probably strace it.

    ( dd if=/dev/urandom bs=1K count=20 ; sleep 2 ) > foo &
    kill -INT $!


Cheers,

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
