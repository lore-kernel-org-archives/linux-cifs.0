From: ronnie sahlberg <ronniesahlberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH][SMB3] New structs and defines from MS-SMB2
Date: Wed, 7 Feb 2018 16:44:09 +1000
Message-ID: <CAN05THTc+3iDwh0gTCUeyFvKRNTHFZ8_rTHyXLW51WM_GKWZtw@mail.gmail.com>
References: <CAH2r5mtATZn8gTiO0j8wdsPFXjbEFJnVNrTzXq+Yn-i4iRzz4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: CIFS <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtATZn8gTiO0j8wdsPFXjbEFJnVNrTzXq+Yn-i4iRzz4g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Reviewed-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Tue, Feb 6, 2018 at 6:54 AM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> I checking through the structs and defines for the new tcon related
> features in MS-SMB2 protocol documentation, I also noticed a few
> missing flags so updated smb2pdu.h to include them.
>
> https://git.samba.org/?p=sfrench/cifs-2.6.git;a=commit;h=022bdb0c463ea4df4ab5039b1685fe54b6810a61
>
> If you notice any additional missing ones (I focused on the last three
> revs to MS-SMB2 over the last couple days so might have missed some
> older ones) or errors, let me know.
>
> --
> Thanks,
>
> Steve
