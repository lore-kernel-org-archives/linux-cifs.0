From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] [CIFS] [1/3 -v3] NTLM auth and sign - Allocate session
 key/client response dynamically
Date: Mon, 25 Oct 2010 12:59:30 -0500
Message-ID: <AANLkTiknLBo6VFS-444gO7=L3jnQg0CEVwbLdS4AeyD2@mail.gmail.com>
References: <1287661375-6954-1-git-send-email-shirishpargaonkar@gmail.com>
	<20101025121410.6a0aef5f@corrin.poochiereds.net>
	<AANLkTik0aRH9NcBjR0AGVgc5V-TwEsV3uMYJ_PhcqvD8@mail.gmail.com>
	<20101025131344.65779724@corrin.poochiereds.net>
	<AANLkTikwVH2L+oXRT8+jp=Xg4H_DMoaezCvcp04kxffx@mail.gmail.com>
	<20101025134751.068706f0@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101025134751.068706f0-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

> Ok. I think the locking around the sequence number could stand some
> improvement. It seems a bit complex -- maybe a simple atomic counter
> would be more appropriate? In any case, it's probably better to leave
> that for a later patch.
>
> You can add my reviewed-by on this one. I don't see any obvious
> problems now.
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>

Jeff, Thanks. I see three issues that need to be addressed once these
NTLM patches are through.

1. purging code obsolet'ed by kernel crypto apis.
2. revisiting logic in cifs_reconnect()
3. data type and/or locking around sequence_number
