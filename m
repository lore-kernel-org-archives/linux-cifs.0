From: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Why do we use a global lock when manipulating MIDs
Date: Mon, 28 May 2012 17:30:22 -0700
Message-ID: <CACyXjPwtjOMispfRE1uy2jTj6oAv4CNburFirWDwDcnhmCNw2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi folks,

I am reading the code because I am interested in adding SMB2.2/3.0
support around multi-connect.

I noticed the following code, which confuses me.

        /* put it on the pending_mid_q */
        spin_lock(&GlobalMid_Lock);
        list_add_tail(&mid->qhead, &server->pending_mid_q);
        spin_unlock(&GlobalMid_Lock);

        rc =3D cifs_sign_smb2(iov, nvec, server, &mid->sequence_number)=
;
        if (rc)
                cifs_delete_mid(mid);
        *ret_mid =3D mid;
        return rc;

Since MIDs are allocated on a per-server basis and the list that the
new struct mid_q_entry is placed on is in the struct TCP_Server_Info
why are we using GlobalMid_Lock. It seems that we could move that
spinlock into struct TCP_Server_Info.

What am I missing here?

--=20
Regards,
Richard Sharpe
(=A6=F3=A5H=B8=D1=BC~=A1H=B0=DF=A6=B3=A7=F9=B1d=A1C--=B1=E4=BE=DE)
