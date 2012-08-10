From: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Possible use-after-free in transport.c:SendReceive and SendReceive2
Date: Fri, 10 Aug 2012 12:36:10 -0700
Message-ID: <CACyXjPw3_d5+hJXVD+wMUvtT7cjqzzPbjLfene0VK07gc+E6bw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi folks,

I have been trawling through the code to get a better understanding of
various things and I came across this curious thing in the smb2dev
branch in git://git.altlinux.org/people/piastry/public/cifs-2.6.git
but it is also in the master branch, it seems.

In transport.c:SendReceive (and SendReceive2 where we do similar things=
) we see:

=2E..
        rc =3D cifs_sync_mid_result(midQ, ses->server);
        if (rc !=3D 0) {
                add_credits(ses->server, 1, 0);
                return rc;
        }

        if (!midQ->resp_buf || !out_buf ||
            midQ->mid_state !=3D MID_RESPONSE_RECEIVED) {
                rc =3D -EIO;
                cERROR(1, "Bad MID state?");
                goto out;
        }

        *pbytes_returned =3D get_rfc1002_length(midQ->resp_buf);
        memcpy(out_buf, midQ->resp_buf, *pbytes_returned + 4);
        rc =3D cifs_check_receive(midQ, ses->server, 0);
=2E..

However, at the end of cifs_sync_mid_result we see:


        DeleteMidQEntry(mid);
        return rc;

and there are no early returns from cifs_sync_mid_result, it seems.
The "mid" in the DeleteMidQEntry call is the same midQ passed to
cifs_sync_mid_result, I believe.

So, it looks like we have a use-after-free situation and thus a race
to get the data out before someone else pollutes it.

Is this correct or have I got the wrong end of the stick here?

--=20
Regards,
Richard Sharpe
(=A6=F3=A5H=B8=D1=BC~=A1H=B0=DF=A6=B3=A7=F9=B1d=A1C--=B1=E4=BE=DE)
