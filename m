From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: fix another memleak, in cifs_root_iget
Date: Wed, 10 Nov 2010 21:40:43 -0600
Message-ID: <AANLkTin17WOAqyid2T_byvjCN7ADespHDOEMd8Ewtibk@mail.gmail.com>
References: <1289423173-7044-1-git-send-email-oskar@scara.com>
	<alpine.LNX.2.00.1011102257400.11302@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Oskar Schirmer <oskar-fYPSZ7JpQqsAvxtiuMwx3w@public.gmane.org>, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	Andrew Hendry <andrew.hendry-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LNX.2.00.1011102257400.11302-h2p7t3/P30RzeRGmFJ5qR7ZzlVVXadcDXqFh9Ls21Oc@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Patch is obviously correct.   Merged.

On Wed, Nov 10, 2010 at 3:59 PM, Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org> wrote:
> On Wed, 10 Nov 2010, Oskar Schirmer wrote:
>
>> cifs_root_iget allocates full_path through
>> cifs_build_path_to_root, but fails to kfree it upon
>> cifs_get_inode_info* failure.
>>
>> Make all failure exit paths traverse clean up
>> handling at the end of the function.
>>
>> Signed-off-by: Oskar Schirmer <oskar-fYPSZ7JpQqsAvxtiuMwx3w@public.gmane.org>
>> Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
>
> I've reviewed your patch (although not actually tested it) and your
> changes look sane.
> So, feel free to add
>
> Reviewed-by: Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>
>
>
> --
> Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org> =A0 =A0 =A0 =A0 =A0 =A0 http://www.cha=
osbits.net/
> Don't top-post =A0http://www.catb.org/~esr/jargon/html/T/top-post.htm=
l
> Plain text mails only, please.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks,

Steve
