From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: fix length checks in checkSMB
Date: Thu, 27 Jan 2011 21:09:12 -0600
Message-ID: <AANLkTimbuWJWAwbmCVVhFub4Y_Yg-QVXoqr96rGhqHd+@mail.gmail.com>
References: <1296132305-21872-1-git-send-email-jlayton@redhat.com>
	<AANLkTi=2A5VUOz7aTCm_EbeRZdD=e7tq=sd3AAPbzTiR@mail.gmail.com>
	<20110127170225.03274b03@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110127170225.03274b03-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Jan 27, 2011 at 4:02 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Thu, 27 Jan 2011 14:41:14 -0600
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> If a server has a bug and sends an SMB which is more than just "roun=
d up" off
>> in length - I can imagine a case for making exceptions depending on =
the
>> details of the type of malformed frame, but since we
>> already allow 512 bytes (for "incorrect server rounding of frame siz=
e" bugs)
>> we should be careful. =A0If the length is more than 512 bytes off - =
this is
>> a server bug and the probability that the rest of the frame is incor=
rect
>> is very high. =A0How off is the frame you want to allow.
>>
>> No objection to fixing the error message - not clear on the other pa=
rt.
>> Generally my intuition is that allowing a badly malformed response
>> without a clear server bug to workaround unnecessarily weakens
>> our validity checking. =A0 The better/stricter the validity checking=
 the more
>> likely we are to throw away attack frames (intentionally illegal res=
ponses
>> designed to mess up the kernel).
>>
>
> I see no problem with allowing an RFC frame up to the size of the
> buffer. By the time we get to this check, we've *already* received it
> into the response buffer. cifs_demultiplex_thread has this check:
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* else we have an SMB response */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if ((pdu_length > CIFSMaxBufSize + MAX=
_CIFS_HDR_SIZE - 4) ||
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(pdu_length < =
sizeof(struct smb_hdr) - 1 - 4)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "Invalid siz=
e SMB length %d pdu_length %d",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0length, pdu_length+4);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_reconnect(server)=
;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0csocket =3D server->ss=
ocket;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wake_up(&server->respo=
nse_q);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> ...so we've already received it into the buffer, and we know that the
> RFC length fits within the buffer, and we've checked that the
> calculated SMB length fits within the RFC length.
>
> So what's the purpose of only allowing an RFC frame that's 512 bytes
> bigger than the SMB? It's certainly inefficient for the server to sen=
d
> us such a frame, but it's not really harmful and I see no need to
> reject it for that reason alone.

I would rather not continue parsing a frame that is clearly broken.  Si=
nce
a legitimate server is unlikely to send such a frame, the probability
of such a frame coming from a hostile server or proxy or man
in the middle is high.   A "random" RFC length that is wrong is likely
to be generated in a random attack, less likely by a legitimate server.


--=20
Thanks,

Steve
