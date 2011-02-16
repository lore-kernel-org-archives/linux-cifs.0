From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: fix broken lanman (lm) auth code
Date: Wed, 16 Feb 2011 09:06:08 -0600
Message-ID: <AANLkTinFs9zFOPV=4v8zTujxzyeS_y1o9W7in4or7L76@mail.gmail.com>
References: <1297811443-4848-1-git-send-email-shirishpargaonkar@gmail.com>
	<20110216075346.2b69c431@tlielax.poochiereds.net>
	<AANLkTinVM2j9kVjreWy+Tk6VFONTo=zEj=s1k-07YViF@mail.gmail.com>
	<20110216100129.5f05c7e3@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110216100129.5f05c7e3-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Feb 16, 2011 at 9:01 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Wed, 16 Feb 2011 08:46:03 -0600
> Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Wed, Feb 16, 2011 at 6:53 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
>> > On Tue, 15 Feb 2011 17:10:43 -0600
>> > shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>> >
>> >> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> >>
>> >>
>> >> Fix lanman (lm) authentication code.
>> >>
>> >> Change lm response length back to 24 from 16.
>> >> Parse lanmani mount option.
>> >> Add code to add odd parity bit to each of the eight bytes of a DE=
S key.
>> >>
>> >>
>> >> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> >> ---
>> >> =A0fs/cifs/cifsglob.h | =A0 =A03 ++-
>> >> =A0fs/cifs/connect.c =A0| =A0 =A03 +++
>> >> =A0fs/cifs/sess.c =A0 =A0 | =A0 =A08 ++++----
>> >> =A0fs/cifs/smbdes.c =A0 | =A0 19 ++++++++++++++++++-
>> >> =A04 files changed, 27 insertions(+), 6 deletions(-)
>> >>
>> >> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> >> index 17afb0f..0b5c950 100644
>> >> --- a/fs/cifs/cifsglob.h
>> >> +++ b/fs/cifs/cifsglob.h
>> >> @@ -710,7 +710,8 @@ require use of the stronger protocol */
>> >> =A0#define =A0 CIFSSEC_MUST_SEAL =A00x40040 /* not supported yet =
*/
>> >> =A0#define =A0 CIFSSEC_MUST_NTLMSSP =A0 =A0 =A0 0x80080 /* raw nt=
lmssp with ntlmv2 */
>> >>
>> >> -#define =A0 CIFSSEC_DEF (CIFSSEC_MAY_SIGN | CIFSSEC_MAY_NTLM | C=
IFSSEC_MAY_NTLMV2)
>> >> +#define =A0 CIFSSEC_DEF (CIFSSEC_MAY_LANMAN | CIFSSEC_MAY_SIGN |=
 \
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFSSEC_MAY_NTLM | CIFS=
SEC_MAY_NTLMV2)
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^^^^
>> > =A0 =A0 =A0 =A0Won't this change enable lanman auth by default? Is=
 that
>> > =A0 =A0 =A0 =A0intended?
>>
>> I think it depends on what server sends in negprot response, the
>> minimun dialect it supports.
>> If the dialect is greater than Lanman2.1, the default auth mech for
>> cifs client is NTLM (ntlmv1)
>> if the dialect is less than or upto Lanman2.1, default auth mech for
>> cifs client is LANMAN (lm).
>>
>
> Historically we've required that the admin
> set /proc/fs/cifs/SecurityFlags to allow LANMAN auth before the clien=
t
> will allow it to be used. I'm not opposed to changing that, but the
> description doesn't even mention anything about that.
>
> I think this ought to be a separate patch with a clearly described
> reason, and probably doesn't belong in 2.6.38. It doesn't seem like
> it's necessary to fix this bug.
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>

I think that is still the case.  If we do not have the code,  we will g=
et error
 CIFS VFS: mount failed weak security disabled in /proc/fs/cifs/Securit=
yFlags
and auth will fail even if admin did necessary to allow LANMAN.
