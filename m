From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Why do we use a global lock when manipulating MIDs
Date: Tue, 29 May 2012 08:30:38 -0500
Message-ID: <CAH2r5mtXCsyuVgNcVZMbk5GW92JH8hXK5RtC=FbF6x039bdeRg@mail.gmail.com>
References: <CACyXjPwtjOMispfRE1uy2jTj6oAv4CNburFirWDwDcnhmCNw2w@mail.gmail.com>
	<CAH2r5muO2JWZn_aE=tNVtuenTktrGOgXwyE0Vs8ueSRsQkPTfw@mail.gmail.com>
	<20120529090355.673b3536@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120529090355.673b3536-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, May 29, 2012 at 8:03 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Mon, 28 May 2012 22:03:44 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Mon, May 28, 2012 at 7:30 PM, Richard Sharpe
>> <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> > Hi folks,
>> >
>> > I am reading the code because I am interested in adding SMB2.2/3.0
>> > support around multi-connect.
>> >
>> > I noticed the following code, which confuses me.
>> >
>> > =A0 =A0 =A0 =A0/* put it on the pending_mid_q */
>> > =A0 =A0 =A0 =A0spin_lock(&GlobalMid_Lock);
>> > =A0 =A0 =A0 =A0list_add_tail(&mid->qhead, &server->pending_mid_q);
>> > =A0 =A0 =A0 =A0spin_unlock(&GlobalMid_Lock);
>> >
>> > =A0 =A0 =A0 =A0rc =3D cifs_sign_smb2(iov, nvec, server, &mid->sequ=
ence_number);
>> > =A0 =A0 =A0 =A0if (rc)
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_delete_mid(mid);
>> > =A0 =A0 =A0 =A0*ret_mid =3D mid;
>> > =A0 =A0 =A0 =A0return rc;
>> >
>> > Since MIDs are allocated on a per-server basis and the list that t=
he
>> > new struct mid_q_entry is placed on is in the struct TCP_Server_In=
fo
>> > why are we using GlobalMid_Lock. It seems that we could move that
>> > spinlock into struct TCP_Server_Info.
>> >
>> > What am I missing here?
>>
>> Yes - probably could be moved to the srv_mutex in struct
>> TCP_Server_Info although it is unlikely to make a measurable
>> difference.
>>
>
> Breaking up that global lock is long overdue, but let's not overload
> the srv_mutex with that -- mutexes have much higher overhead than a
> spinlock. A new per-TCP_Server_Info spinlock would be preferable.

agreed


--=20
Thanks,

Steve
