From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: fix length checks in checkSMB
Date: Thu, 27 Jan 2011 14:41:14 -0600
Message-ID: <AANLkTi=2A5VUOz7aTCm_EbeRZdD=e7tq=sd3AAPbzTiR@mail.gmail.com>
References: <1296132305-21872-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1296132305-21872-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If a server has a bug and sends an SMB which is more than just "round u=
p" off
in length - I can imagine a case for making exceptions depending on the
details of the type of malformed frame, but since we
already allow 512 bytes (for "incorrect server rounding of frame size" =
bugs)
we should be careful.  If the length is more than 512 bytes off - this =
is
a server bug and the probability that the rest of the frame is incorrec=
t
is very high.  How off is the frame you want to allow.

No objection to fixing the error message - not clear on the other part.
Generally my intuition is that allowing a badly malformed response
without a clear server bug to workaround unnecessarily weakens
our validity checking.   The better/stricter the validity checking the =
more
likely we are to throw away attack frames (intentionally illegal respon=
ses
designed to mess up the kernel).

On Thu, Jan 27, 2011 at 6:45 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> The cERROR message in checkSMB when the calculated length doesn't mat=
ch
> the RFC1001 length is incorrect in many cases. It always says that th=
e
> RFC1001 length is bigger than the SMB, even when it's actually the
> reverse.
>
> Fix the error message to say the reverse of what it does now and remo=
ve
> the arbitrary check when an RFC1001 length is larger than the SMB.
> There's no reason to reject those packets since we can just ignore th=
e
> junk that's hanging off the end.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/misc.c | =A0 19 +++----------------
> =A01 files changed, 3 insertions(+), 16 deletions(-)
>
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index 72e99ec..959d629 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -467,23 +467,10 @@ checkSMB(struct smb_hdr *smb, __u16 mid, unsign=
ed int length)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (((4 + len) & 0xFFF=
=46) =3D=3D (clc_len & 0xFFFF))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return=
 0; /* bcc wrapped */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Calculated size %d vs length %=
d mismatch for mid %d",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Calculated size %u vs length %=
u mismatch for mid=3D%u",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0clc_le=
n, 4 + len, smb->Mid);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Windows XP can return a few bytes to=
o much, presumably
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 an illegal pad, at the end of byte rang=
e lock responses
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 so we allow for that three byte pad, as=
 long as actual
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 received length is as long or longer th=
an calculated length */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* We have now had to extend this more,=
 since there is a
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 case in which it needs to be bigger sti=
ll to handle a
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 malformed response to transact2 findfir=
st from WinXP when
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 access denied is returned and thus bcc =
and wct are zero
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 but server says length is 0x21 bytes to=
o long as if the server
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 forget to reset the smb rfc1001 length =
when it reset the
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 wct and bcc to minimum size and drop th=
e t2 parms and data */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((4+len > clc_len) && (len <=3D clc_=
len + 512))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "RFC1001 size=
 %d bigger than SMB for Mid=3D%d",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (4+len < clc_len) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "RFC1001 size=
 %d smaller than SMB for mid=3D%u",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0len, smb->Mid);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 1;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> --
> 1.7.3.4
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
