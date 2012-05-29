From: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Why do we use a global lock when manipulating MIDs
Date: Tue, 29 May 2012 06:50:45 -0700
Message-ID: <CACyXjPznqEUKvWZXB4grUVzF=L5D7mb3a9jc4nLz=con+aRfpw@mail.gmail.com>
References: <CACyXjPwtjOMispfRE1uy2jTj6oAv4CNburFirWDwDcnhmCNw2w@mail.gmail.com>
	<CAH2r5muO2JWZn_aE=tNVtuenTktrGOgXwyE0Vs8ueSRsQkPTfw@mail.gmail.com>
	<20120529090355.673b3536@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120529090355.673b3536-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, May 29, 2012 at 6:03 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
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
>> >        /* put it on the pending_mid_q */
>> >        spin_lock(&GlobalMid_Lock);
>> >        list_add_tail(&mid->qhead, &server->pending_mid_q);
>> >        spin_unlock(&GlobalMid_Lock);
>> >
>> >        rc =3D cifs_sign_smb2(iov, nvec, server, &mid->sequence_num=
ber);
>> >        if (rc)
>> >                cifs_delete_mid(mid);
>> >        *ret_mid =3D mid;
>> >        return rc;
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

Well, I wanted to talk about that. Take for example, this function:

int
cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
                unsigned int nvec, mid_receive_t *receive,
                mid_callback_t *callback, void *cbdata, const int optyp=
e)
{
        int rc;
        struct mid_q_entry *mid;

        rc =3D wait_for_free_request(server, optype);
        if (rc)
                return rc;

        mutex_lock(&server->srv_mutex);
        rc =3D setup_async_request(server, iov, nvec, &mid);
        if (rc) {
                mutex_unlock(&server->srv_mutex);
                add_credits(server, 1, optype);
                wake_up(&server->request_q);
                return rc;
        }

        mid->receive =3D receive;
        mid->callback =3D callback;
        mid->callback_data =3D cbdata;
        mid->mid_state =3D MID_REQUEST_SUBMITTED;

        cifs_in_send_inc(server);
        rc =3D smb_sendv(server, iov, nvec);
        cifs_in_send_dec(server);
        cifs_save_when_sent(mid);
        mutex_unlock(&server->srv_mutex);

        if (rc)
                goto out_err;

        return rc;
out_err:
        cifs_delete_mid(mid);
        add_credits(server, 1, optype);
        wake_up(&server->request_q);
        return rc;
}

We already hold the server mutex and by shifting the MID-number lock
into the server structure we could eliminate that lock altogether. I
am sure that we could make the case that MIDs can only be allocated if
we are holding the server mutex. (Although, there is another issue
here, which is that the spec says that the PIDMID pair must be unique,
not that MID must be unique. However, I don't think that is a big
problem here. It will only be a problem when we have a big Linux
server with a large number of users accessing a CIFS share.)

The coding in the error paths here is quite contrived, as well, it
seems to me, for a number of reasons.

I would have expected to see the mutex being dropped in the error path
and just before the return of rc.

(there is the additional problem that cifs_delete_mid is deleted on
error paths in functions that are called as well that complicates the
error paths here, but I would prefer to see all errors handled by
branching to some point at the end of the function.) Using a
consistent idiom helps prevent errors creeping in.

--=20
Regards,
Richard Sharpe
(=A6=F3=A5H=B8=D1=BC~=A1H=B0=DF=A6=B3=A7=F9=B1d=A1C--=B1=E4=BE=DE)
