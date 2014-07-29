From: "Bob Balsover" <cifs-MPfZBXey4klWk0Htik3J/w@public.gmane.org>
Subject: Re: "CIFS VFS: Server requires packet signing to be enabled" with
 a krb5i mount
Date: Tue, 29 Jul 2014 09:54:36 -0700
Message-ID: <e5b4ca621b247beaddfb6b1778dcc391.squirrel@mail.balsover.com>
References: <CAFknXfCta1aj2=8GqxK6PN5ryprL6AsJ2HNDY+ToaufBnvvgbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kyle Harrigan" <kwharrigan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFknXfCta1aj2=8GqxK6PN5ryprL6AsJ2HNDY+ToaufBnvvgbw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Kyle,

We had a similar problem with a kernel version close to yours where it did
not handle extended security correctly; we had to change a few lines
sess.c. I am sorry but I don't have access to that source code right now
but if you diff what you have against a more recent kernel that has the
problem corrected you should see the differences. You can also look
through the release notes to see the patch that corrected this issue.

-Bob



> I have a number of mounts to WS2008 using krb5i and multiuser.
>
> /etc/fstab:
> //mountname /location cifs sec=krb5i,multiuser,user=MACHINE$ 0 0
>
> Is this expected behavior?  Can the message be safely ignored or is it
> indicative of an underlying issue?  I thought krb5i would be
> sufficient indication that I intend for packet signing to be enabled.
>
> I have played around with modifying /proc/fs/cifs/SecurityFlags
> (0x9009) in /etc/rc.local, but doesn't seem to help.
>
> Kernel is 2.6.32-358.
>
> Thanks.
>
>
>
> --
> -Kyle
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
