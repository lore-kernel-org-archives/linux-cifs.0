From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [GSoC finished] SMB2 protocol support for CIFS Linux kernel module
Date: Wed, 24 Aug 2011 13:39:23 -0500
Message-ID: <CAH2r5mupeO8NjLeo1KkX1RPS7zG=74Y8ZCJd8KPontJ_sxnzFA@mail.gmail.com>
References: <CAKywueS1O6d=T49tz5zVK=npZ9K5-Pw=AsjAKL2bAHJTi7iB4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueS1O6d=T49tz5zVK=npZ9K5-Pw=AsjAKL2bAHJTi7iB4w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is excellent.

Also note the huge increase in scalability that SMB2 will allow (over
cifs) due to 1) dynamic scaling of number of in-flight requests (based
on "credits" that the server grants) which is more effective for flow
control than simply using the tcp window to throttle the client back
and 2) larger i/o sizes

On Wed, Aug 24, 2011 at 3:55 AM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =
wrote:
> Hi all!
>
> The GSoC program finished and I want to share the results. I created =
a
> blog post where I described advantages of using SMB2.1 leases caching
> strategy in cases where we need to keep several file descriptors of
> the same file opened during an application execution:
>
> http://pshilovsky.blogspot.com/2011/08/gsoc-2011-results.html
>
> Your comments are appreciated!
>
> --
> Best regards,
> Pavel Shilovsky.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks,

Steve
