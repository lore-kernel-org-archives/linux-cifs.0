From: =?UTF-8?Q?Johannes_Thr=C3=A4n?= <johannes.thraen-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Re: vim reports file having changed
Date: Fri, 2 Dec 2011 18:27:34 +0100
Message-ID: <CAFbNW2FJuRQMLspnSqGcvNRfCT=2zsVO+x0eQJ6mTFKJTQkdBw@mail.gmail.com>
References: <CAFbNW2Fv58h_r1rmtk0rHg+uJ0C9i1Rtoy2DEDm-Hxw-ZtK_mQ@mail.gmail.com>
	<20111201104417.4b3ce577@barsoom.rdu.redhat.com>
	<CADT32eJT=J+Jip_LFTX8SKZcEYUgdP7k=3PkE=q5UeH1rL2Ehg@mail.gmail.com>
	<CAFbNW2EQC5d506pXTzJUMtHGUL-76Wz9CoVTJkf0WAdb5VQX1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFbNW2EQC5d506pXTzJUMtHGUL-76Wz9CoVTJkf0WAdb5VQX1w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

I found out that vim remembers the last modified time, size, mode and
the inode number to monitor file changes.

I also tested the issue with other windows servers. With windows 7
everthing's fine and we happen to have another windows server 2003,
where the problem does not occur.
I found out, that the problematic server is in fact a "small business
server", which is also seems to be a kind of windows server 2003 as
reported by /proc/fs/cifs/DebugData. The output of
/proc/fs/cifs/DebugData for both only differs in "secmode":

good server: [...]Local Users To Server: 1 SecMode: 0x3 Req On Wire: 0[=
=2E..]
bad   server: [...]Local Users To Server: 1 SecMode: 0xf Req On Wire: 0=
[...]

perhaps this helps?


On Thu, Dec 1, 2011 at 7:22 PM, Johannes Thr=C3=A4n
<johannes.thraen-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org> wrote:
> sorry for having been unspecific:
> with sometime i mean: some seconds after first saving the file.
> sometimes 2 sometimes 20 not more. as I recreated the error, I found
> out, it only occurs after saving the file once.
> the exact error message vim confronts me with is:
>
> WARNING: The file has been changed since reading it!!!
> Do you really want to write to it (y/n)?
>
> I have no idea how vim determines file changes in terms of system
> calls. the vim maintainer was neither polite nor helpful, he just sen=
t
> me here. I asked him again, perhaps he'll answer. Until then I strace=
d
> -t the thing and prefiltered the output. the test file's name is
> "test" and it contains the text "this is a test". I saved the file
> twice, the first save went well, the second save (few seconds later)
> didn't. see attachment.
>
> thanks!
>
>
> On Thu, Dec 1, 2011 at 4:56 PM, Shirish Pargaonkar
> <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> On Thu, Dec 1, 2011 at 9:44 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrot=
e:
>>> On Wed, 30 Nov 2011 15:25:01 +0100
>>> Johannes Thr=C3=A4n <johannes.thraen-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org> wrote:
>>>
>>>> Hi all,
>>>>
>>>> I reported this before here, it somehow went under. So I'll try ag=
ain:
>>>>
>>>> When I open a file which is located on a cifs-mounted windows shar=
e
>>>> with vim, vim will after some time always report the file as havin=
g
>>>> changed upon saving, regardless whether it has actually changed or
>>>> not.
>>>>
>>>> I reported this also to the vim maintainer who told me, there he
>>>> doesn't know of a similar problem with samba. Ergo it's probably a
>>>> problem with cifs.
>>>> I work on a daily basis with mentioned setup, so I would be vary g=
lad
>>>> to help resolve it.
>>>>
>>>> mount.cifs -v gives 4.5, I use kubuntu 11.04 and vim 7.2
>>>>
>>>
>>> Unfortunately, this sort of report doesn't help us to help you very
>>> much. I have no idea what vim is actually complaining about when it
>>> says that the file has changed.
>>>
>>> As it's a kernel filesystem, it primarily deals with userspace code=
 via
>>> system calls. If you can phrase your problem in that context then
>>> that would help. We'd need to know what vim is actually looking at =
to
>>> detect that the file has changed. Is it the mtime?
>>>
>>> --
>>> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-cif=
s" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
>>>
>>
>> yes, that would be useful. I just tried with vim 7.2.22, cifs versio=
n 1.76
>> against a Windows 2003 server and after two minutes of opening a fil=
e
>> and while closing, no errors or messages.
>>
>> What is the exact error message by vim? =C2=A0And how long is "somet=
ime"?
>> A trace data (strace, wireshark, tcpdump) obtained while
>> encountering/recreating the problem would help.
