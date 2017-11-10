From: ronnie sahlberg <ronniesahlberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: compound requests roadmap
Date: Sat, 11 Nov 2017 03:20:11 +1000
Message-ID: <CAN05THQ5KHG+ukRTJ+tGxDpwTnWdBiMhVhGfWRSY_=BfNu4Vtg@mail.gmail.com>
References: <87fu9mf77y.fsf@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87fu9mf77y.fsf-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

That sounds like a good plan.

I would split it up even more.
Instead of having a SMB2_xxx_send() function that both encodes the pdu
into a struct kvec
but then also, conditionally, sends the PDU, I would set it up as :

SMB2_xxx_encode(..., struct kvec **out_iov, int out_niov)
{
    struct kvec *iov;
    smb2_xxx_req *req =3D smb2_plain_req_init(...)
    // ... fill up req members ...
    // and return a struct kvec for the PDU.
    ....
}

where the encoding function will just encode the request into a kvec
and return it.
For every such function, out_iov[0] contains the smb2 header so we can
later inspect
and modify it, for example by setting NextCommand, Mid etc.

For example SMB2_open_encode(...) would then basically be all the code
in the current in the current
SMB2_open() up to but not including the line :

rc =3D smb2_send_recv(...)


Then the compounding could look like this :
    struct smb2_creq creq;

    smb2_creq_init(&creq, ...);

    rc =3D SMB2_xxx_encode(tcon, ..., out_iov, out_niov);
    if (rc)
          //  error handling
    smb2_creq_add(&creq, out_iov, out_niov);

    rc =3D SMB2_yyy_encode(tcon, ..., out_iov, out_niov);
    if (rc)
          //  error handling
    smb2_creq_add(&creq, out_iov, out_niov);


    smb2_creq_send_recv(&creq, ...);


Inside the function smb2_creq_send_recv() you would then concatenate
all the struct kvec into a single big struct kvec with a leading
rfc1004 4 byte iov.
As part of concatenating all the struct kvec, you would also update
NextCommand, Mid and add padding as required.


You can also see how I do compounding in libsmb2 for ideas:
 https://github.com/sahlberg/libsmb2/blob/master/lib/libsmb2.c#L1508



But first we need to get rid of the annoying rfc1002 header from all
request and response structures :-)


On Sat, Nov 11, 2017 at 2:07 AM, Aur=C3=A9lien Aptel <aaptel-IBi9RG/b67k@public.gmane.org> wrot=
e:
> Hello linux-cifs,
>
> I've been looking into adding compound requests for some time and
> Ronnie's latest patch series is one of the first step in the right
> direction.
>
> I've talked with Pavel at SDC and he gave me great advices although a
> lot of it went over my head at the time. I have the notes from that
> discussion, which I'm still trying to make sense of now that I'm more
> familiar with the parts involved.
>
> Compound requests are just a bundle of requests sent together to save
> roundtrips. The server can send back compounded responses too.
>
> The most important SMB2 header field related to them is the NextCommand,
> which is an offset that lets the server know where the next request is
> in the payload.
>
> You can make 2 types of compound requests, which is specified via a
> header flag: related and unrelated requests.
>
> Related requests are requests that kind of rely on each other e.g. open
> a file, do X with it, close. You need to give the FID of the file you
> haven't opened yet to do the X command and to close the file. Marking
> the bundle as "related requests" allow to use a special FID (0xfffff...)
> to mean "actually use the FID obtained from the previous open".
>
> Unrelated requests are just regular valid requests bundled together.
>
> Here are my ideas for implementations.
>
> First we need to remove the netbios header (aka rfc1002 len) from the
> smb2 header structures and let the code that send and receive
> respectively add and remove it.
>
> We need to do this because the netbios header is not repeated for each
> request in the bundle of requests. It only appears once and the length
> will be the length of the bundle.
>
> This is what Ronnie started.
>
> From there you can have a function that accumulates smb2 commands in
> kvecs, setting the next command offset and flags properly each time and
> sends them. But can we really do it that way?
>
> I have started to write some code that basically reimplements
> smb2_open_op_close() to do everything in one kvec array... but then you
> hit the mid layer.
>
> Message ID or mid is the object used to represent a request, its
> response and some of the data associated with them. There's a queue of
> them (cf struct mid_q_entry) that is consumed by the cifsd kernel
> thread, who handles the (de)multiplexation of the packets on the tcp
> connection. In particular, a mid entry has a callback function pointer
> that is called when the response arrives.
>
> A mid entry represents a single request, so now that we have several in
> one, we need to create a mid for each, as the server doesn't have to
> reply to them in a compound way and might just send multiple simple smb2
> responses. So a having a kvec array that represents the bundle is not
> good, we have to reparse it to make the individual mid...
>
> In the open/X/close usecase, we only want to wait for the X response so
> we can probably hack something to make the mid entry of the bundle only
> wait for X...
>
> But in the general case --if we want to go beyond the most common and
> already very useful open/x/close usecase-- we probably want a way to
> make a batch and wait on it. I was thinking of introducting a Compound
> REQuest (creq) struct to accumulate the requests and modify the PDU
> routines to write in the creq and return early (before send_recv) if its
> not NULL.
>
>     struct smb2_creq creq;
>
>     smb2_creq_init(&creq, tcon, ...);
>
>     SMB2_xxx_send(&creq, ...);
>     SMB2_yyy_send(&creq, ...);
>     SMB2_zzz_send(&creq, ...);
>
>     smb2_creq_send_recv(&creq, ...);
>
> The send_recv call would block until we have a response for
> everything. We can also imagine a flag in SMB2_* calls to hint at whether
> we want to wait for it.
>
> PDU routines would be split into packet crafting (pre send_recv) and
> response handling (post send_recv) the code would be doing something like=
:
>
> SMB2_xxx_send(creq)
> {
>     smb2_xxx_req *req =3D smb2_plain_req_init(...)
>     // ... fill up req members ...
>
>     if (creq) {
>         return smb2_creq_add(creq, req, ...);
>     }
>
>     // otherwise send
>     return smb2_send_recv(req, ..);
> }
>
> SMB2_xxx_recv()
> {
>     // old post send_recv code to handle results
> }
>
> In turn smb2_creq_add() would add the request to the creq and
> smb2_creq_send_recv() would send everything and generata a mid_q_entry
> for each.
>
> I think this design is somewhat similar to the send/recv/done functions
> in Samba. There might be a simpler way I've overlooked.
>
> Cheers,
>
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
> GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton, HRB 21284 (AG N=
=C3=BCrnberg)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
