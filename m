From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3.12-rc4] cifs: ntstatus_to_dos_map[] is not terminated
Date: Sun, 13 Oct 2013 21:25:50 -0500
Message-ID: <CAH2r5mvduivP8vddnZ8ybCZZ1=48NmMCb1gonOXe=D8aRJW_uQ@mail.gmail.com>
References: <1381692543-41226-1-git-send-email-tim.gardner@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Tim Gardner <tim.gardner-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1381692543-41226-1-git-send-email-tim.gardner-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Merged into cifs-2.6.git

(for-next and for-linus branches)

Thoughts about suitability for stable anyone?

On Sun, Oct 13, 2013 at 2:29 PM, Tim Gardner <tim.gardner-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> wrote:
> Functions that walk the ntstatus_to_dos_map[] array could
> run off the end. For example, ntstatus_to_dos() loops
> while ntstatus_to_dos_map[].ntstatus is not 0. Granted,
> this is mostly theoretical, but could be used as a DOS attack
> if the error code in the SMB header is bogus.
>
> Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> Signed-off-by: Tim Gardner <tim.gardner-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> ---
>  fs/cifs/netmisc.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
> index af847e1..651a527 100644
> --- a/fs/cifs/netmisc.c
> +++ b/fs/cifs/netmisc.c
> @@ -780,7 +780,9 @@ static const struct {
>         ERRDOS, ERRnoaccess, 0xc0000290}, {
>         ERRDOS, ERRbadfunc, 0xc000029c}, {
>         ERRDOS, ERRsymlink, NT_STATUS_STOPPED_ON_SYMLINK}, {
> -       ERRDOS, ERRinvlevel, 0x007c0001}, };
> +       ERRDOS, ERRinvlevel, 0x007c0001}, {
> +       0, 0, 0 }
> +};
>
>  /*****************************************************************************
>   Print an error message from the status code
> --
> 1.7.9.5
>



-- 
Thanks,

Steve
