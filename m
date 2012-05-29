From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Why do we use a global lock when manipulating MIDs
Date: Mon, 28 May 2012 22:03:44 -0500
Message-ID: <CAH2r5muO2JWZn_aE=tNVtuenTktrGOgXwyE0Vs8ueSRsQkPTfw@mail.gmail.com>
References: <CACyXjPwtjOMispfRE1uy2jTj6oAv4CNburFirWDwDcnhmCNw2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACyXjPwtjOMispfRE1uy2jTj6oAv4CNburFirWDwDcnhmCNw2w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, May 28, 2012 at 7:30 PM, Richard Sharpe
<realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi folks,
>
> I am reading the code because I am interested in adding SMB2.2/3.0
> support around multi-connect.
>
> I noticed the following code, which confuses me.
>
> =A0 =A0 =A0 =A0/* put it on the pending_mid_q */
> =A0 =A0 =A0 =A0spin_lock(&GlobalMid_Lock);
> =A0 =A0 =A0 =A0list_add_tail(&mid->qhead, &server->pending_mid_q);
> =A0 =A0 =A0 =A0spin_unlock(&GlobalMid_Lock);
>
> =A0 =A0 =A0 =A0rc =3D cifs_sign_smb2(iov, nvec, server, &mid->sequenc=
e_number);
> =A0 =A0 =A0 =A0if (rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_delete_mid(mid);
> =A0 =A0 =A0 =A0*ret_mid =3D mid;
> =A0 =A0 =A0 =A0return rc;
>
> Since MIDs are allocated on a per-server basis and the list that the
> new struct mid_q_entry is placed on is in the struct TCP_Server_Info
> why are we using GlobalMid_Lock. It seems that we could move that
> spinlock into struct TCP_Server_Info.
>
> What am I missing here?

Yes - probably could be moved to the srv_mutex in struct
TCP_Server_Info although it is unlikely to make a measurable
difference.

--=20
Thanks,

Steve
