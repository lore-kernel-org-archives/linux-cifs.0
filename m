From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make extended
 file stats available [ver #6]
Date: Thu, 18 Jul 2013 08:48:48 -0500
Message-ID: <CAH2r5mvrkYxcc+Nskmk6HNkLEV43VW-EXTcPp=vazB3th_C4ig@mail.gmail.com>
References: <loom.20130717T160052-124@post.gmane.org>
	<CAH2r5mue79VBqr24ie59mr8mYZLDPmnB2FMG_BB1ZoEnh8uGeA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mue79VBqr24ie59mr8mYZLDPmnB2FMG_BB1ZoEnh8uGeA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I did not think the patch series for support of create time was merged yet.

The cifs filesystem can expose the birth time through extended
attributes but as far as I know there is no way to save this on Linux.

Has something changed?

Probably best to ask about this on linux fs-devel mailing list


On Wed, Jul 17, 2013 at 9:03 AM, Enda <enda_k2-/E1597aS9LQAvxtiuMwx3w@public.gmane.org> wrote:
>
> Copying a file using cp on a NTFS filesystem to an ext4 filesystem does not
> copy the birth time:
>
> $ cp --preserve=all ntfs.txt ~
>
> $ stat ~/ntfs.txt
> ...
>  Birth: -
>
>
>
> -- Enda
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




--
Thanks,

Steve



--
Thanks,

Steve
