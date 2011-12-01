From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: vim reports file having changed
Date: Thu, 1 Dec 2011 09:56:29 -0600
Message-ID: <CADT32eJT=J+Jip_LFTX8SKZcEYUgdP7k=3PkE=q5UeH1rL2Ehg@mail.gmail.com>
References: <CAFbNW2Fv58h_r1rmtk0rHg+uJ0C9i1Rtoy2DEDm-Hxw-ZtK_mQ@mail.gmail.com>
	<20111201104417.4b3ce577@barsoom.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?ISO-8859-1?Q?Johannes_Thr=E4n?= <johannes.thraen-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111201104417.4b3ce577-xSBYVWDuneFaJnirhKH9O4GKTjYczspe@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Dec 1, 2011 at 9:44 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Wed, 30 Nov 2011 15:25:01 +0100
> Johannes Thr=E4n <johannes.thraen-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org> wrote:
>
>> Hi all,
>>
>> I reported this before here, it somehow went under. So I'll try agai=
n:
>>
>> When I open a file which is located on a cifs-mounted windows share
>> with vim, vim will after some time always report the file as having
>> changed upon saving, regardless whether it has actually changed or
>> not.
>>
>> I reported this also to the vim maintainer who told me, there he
>> doesn't know of a similar problem with samba. Ergo it's probably a
>> problem with cifs.
>> I work on a daily basis with mentioned setup, so I would be vary gla=
d
>> to help resolve it.
>>
>> mount.cifs -v gives 4.5, I use kubuntu 11.04 and vim 7.2
>>
>
> Unfortunately, this sort of report doesn't help us to help you very
> much. I have no idea what vim is actually complaining about when it
> says that the file has changed.
>
> As it's a kernel filesystem, it primarily deals with userspace code v=
ia
> system calls. If you can phrase your problem in that context then
> that would help. We'd need to know what vim is actually looking at to
> detect that the file has changed. Is it the mtime?
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

yes, that would be useful. I just tried with vim 7.2.22, cifs version 1=
=2E76
against a Windows 2003 server and after two minutes of opening a file
and while closing, no errors or messages.

What is the exact error message by vim?  And how long is "sometime"?
A trace data (strace, wireshark, tcpdump) obtained while
encountering/recreating the problem would help.
