From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix symbolic links usage
Date: Sat, 2 Nov 2013 23:47:16 +0400
Message-ID: <CAKywueQGBtpvJwLjPja_xN5OA54qRC=24zSC9pcwhCrRt5Z86A@mail.gmail.com>
References: <1383314259-4694-1-git-send-email-piastryyy@gmail.com>
	<20131101134219.02d33b75@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Joao Correia <joaomiguelcorreia-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131101134219.02d33b75-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2013/11/1 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> This looks much better for performance, but I think it really shines a
> light on what an abortion the query_path_info and query_file_info
> operations are. They work with a FILE_ALL_INFO struct which is SMB1
> specific, so for SMB2/3 we have to convert data to something that
> doesn't even match the protocol.
>
> I think it would be best to base this fix on top of a patchset to fix
> that properly. Those functions should be changed to pass data around in
> a cifs_fattr. With that, you could just add a new cifs_fattr->flags
> value and you wouldn't need to add this extra bool * argument.

I agree that using cifs_fattr structure rather than FILE_ALL_INFO
simplifies things and makes the code cleaner. But we have a problem in
the 3.11 stable branch and I think we should fix it without many
patches (code changes). We can apply this patch for stable and then
convert the code to use cifs_fattr structure in query path/file info
in mainline. Right?

-- 
Best regards,
Pavel Shilovsky.
