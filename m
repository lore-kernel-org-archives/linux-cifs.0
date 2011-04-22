From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mids and cifs sendrcv2
Date: Fri, 22 Apr 2011 14:26:11 +0400
Message-ID: <BANLkTim4u+Kp90xfJAqB9BXVcQmK6Es=VA@mail.gmail.com>
References: <BANLkTi=tUrieqB4jCo0GRX3Np10JxJUP9Q@mail.gmail.com>
	<BANLkTikLfy=4BPESJEmOe+mBhKSRtC=W6A@mail.gmail.com>
	<BANLkTiknBBtzjEjXK5N=SpUaU=b4GAos_A@mail.gmail.com>
	<20110415112123.0a3c2996@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110415112123.0a3c2996-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/4/15 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Fri, 15 Apr 2011 08:38:59 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Fri, Apr 15, 2011 at 5:45 AM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8@public.gmane.org=
m> wrote:
>> > 2011/4/8 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> >> Update on cifs vs. smb2 mids, and the smb2 sendrcv2. =A0 Jeff had
>> >> suggested more closely matching the cifs and smb2 mids, in partic=
ular
>> >> extending the 16 bit cifs mid (multiplex identifier for inflight
>> >> network requests) to the 64 bit size needed for smb2 (and thus ma=
sking
>> >> the mid when used for cifs) and having cifs ignore the various sm=
b2
>> >> unique fields in the mid (which makes the mid larger for cifs).
>> >> Since the smb2 code in cifs-2.6.git (put in February and early Ma=
rch)
>> >> has now been rereviewed, the next step in the smb2 merge is posti=
ng
>> >> and reviewing the transport routine for smb2 (smb2_sendrcv2 or re=
using
>> >> cifs_sendrcv2) - the latter may make more sense if we go to a com=
mon
>> >> mid for cifs and smb2. =A0 At the fs summit, Jeff and Jeremy and =
I
>> >> talked about this, but Pavel and others may have opinions on this
>> >> topic. =A0 As soon as the cifs merge activity settles down for 2.=
6.39, I
>> >> plan to post sendrcv2 alternatives and then begin work with Pavel=
 on
>> >> the superblock, file and inode routines and seeing whether for sm=
b2
>> >> they should be smb2 unique (as we originally expected since smb2 =
is
>> >> handle based, and simpler) and look more like they did in the smb=
2.ko
>> >> work that Pavel did last summer or should be more common with the=
 cifs
>> >> routines.
>> >>
>> >> --
>> >> Thanks,
>> >>
>> >> Steve
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-c=
ifs" in
>> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> >> More majordomo info at =A0http://vger.kernel.org/majordomo-info.h=
tml
>> >>
>> >
>> > I suggest to make cifs and smb2 protocol mid structures use common
>> > structure that has equals fields for both and then expand this
>> > structure for protocol-dependent things.
>> >
>> > It can look like this:
>> >
>> > /* one of these for every pending CIFS request to the server */
>> > struct mid_q_entry {
>> > =A0 =A0 =A0 =A0__u8 protocol_id;
>> > =A0 =A0 =A0 =A0struct list_head qhead; /* mids waiting on reply fr=
om this server */
>> > =A0 =A0 =A0 =A0int midState; =A0 /* wish this were enum but can no=
t pass to wait_event */
>> > =A0 =A0 =A0 =A0unsigned long when_alloc; =A0/* when mid was create=
d */
>> > #ifdef CONFIG_CIFS_STATS2
>> > =A0 =A0 =A0 =A0unsigned long when_sent; /* time when smb send fini=
shed */
>> > =A0 =A0 =A0 =A0unsigned long when_received; /* when demux complete=
 (taken off wire) */
>> > #endif
>> > =A0 =A0 =A0 =A0bool largeBuf:1; =A0 =A0 =A0 =A0/* if valid respons=
e, is pointer to large buf */
>> > =A0 =A0 =A0 =A0void *resp_buf; =A0 =A0 =A0 =A0 /* response buffer =
*/
>> > =A0 =A0 =A0 =A0mid_callback_t *callback; /* call completion callba=
ck */
>> > =A0 =A0 =A0 =A0void *callback_data; =A0 =A0 =A0/* general purpose =
pointer for callback */
>> > };
>> >
>> > struct cifs_mid_q_entry {
>> > =A0 =A0 =A0 =A0struct mid_q_entry mid_q;
>> > =A0 =A0 =A0 =A0__u16 mid; =A0 =A0 =A0 =A0 =A0 =A0 =A0/* multiplex =
id */
>> > =A0 =A0 =A0 =A0__u32 sequence_number; =A0/* for CIFS signing */
>> > =A0 =A0 =A0 =A0__u8 command; =A0 =A0 =A0 =A0 =A0 /* smb command co=
de */
>> > =A0 =A0 =A0 =A0__u16 pid; =A0 =A0 =A0 =A0 =A0 =A0 =A0/* process id=
 */
>> > =A0 =A0 =A0 =A0bool multiRsp:1; =A0 =A0 =A0 =A0/* multiple trans2 =
responses for one request =A0*/
>> > =A0 =A0 =A0 =A0bool multiEnd:1; =A0 =A0 =A0 =A0/* both received */
>> > };
>> >
>> > struct smb2_mid_q_entry {
>> > =A0 =A0 =A0 =A0struct mid_q_entry mid_q;
>> > =A0 =A0 =A0 =A0__u64 mid; =A0 =A0 =A0 =A0 =A0 =A0 =A0/* multiplex =
id(s), bigger for smb2 */
>> > =A0 =A0 =A0 =A0__le16 command; =A0 =A0 =A0 =A0 /* smb2 command cod=
e */
>> > =A0 =A0 =A0 =A0__u32 pid; =A0 =A0 =A0 =A0 =A0 =A0 =A0/* process id=
 - bigger for smb2 than cifs */
>> > };
>>
>> I think nested mid structures (around a base of common mid fields)
>> like the above is going to be the easiest way to handle the differen=
ces.
>>
>> I don't understand your PROTOCOL_ID #define though - we
>> identify smb2 vs. cifs via a bool in the tcp server info struct,
>> and presumably if we don't have access to the tcp server
>> info struct we would have to add a field in the base mid
>> (struct mid_q_entry) that indicates smb2 vs. cifs..
>>
>
> Why do even that? Why not a common mid struct that's simply a little =
larger? Sure it means slightly more memory consumption, but we never ha=
ve that many in flight. Something like:
>
> struct mid_q_entry {
> =A0 =A0 =A0 =A0__u8 protocol_id;
> =A0 =A0 =A0 =A0struct list_head qhead; /* mids waiting on reply from =
this server */
> =A0 =A0 =A0 =A0int midState; =A0 /* wish this were enum but can not p=
ass to wait_event */
> =A0 =A0 =A0 =A0unsigned long when_alloc; =A0/* when mid was created *=
/
> #ifdef CONFIG_CIFS_STATS2
> =A0 =A0 =A0 =A0unsigned long when_sent; /* time when smb send finishe=
d */
> =A0 =A0 =A0 =A0unsigned long when_received; /* when demux complete (t=
aken off wire) */
> #endif
> =A0 =A0 =A0 =A0bool largeBuf:1; =A0 =A0 =A0 =A0/* if valid response, =
is pointer to large buf */
> =A0 =A0 =A0 =A0void *resp_buf; =A0 =A0 =A0 =A0 /* response buffer */
> =A0 =A0 =A0 =A0mid_callback_t *callback; /* call completion callback =
*/
> =A0 =A0 =A0 =A0void *callback_data; =A0 =A0 =A0/* general purpose poi=
nter for callback */
> =A0 =A0 =A0 =A0__u64 mid; =A0 =A0 =A0 =A0 =A0 =A0 =A0/* multiplex id =
*/
> =A0 =A0 =A0 =A0__le16 command; =A0 =A0 =A0 =A0 /* command code */
> =A0 =A0 =A0 =A0__u32 pid; =A0 =A0 =A0 =A0 =A0 =A0 =A0/* process id */
> =A0 =A0 =A0 =A0__u32 sequence_number; =A0/* for CIFS signing */
> =A0 =A0 =A0 =A0bool multiRsp:1; =A0 =A0 =A0 =A0/* multiple trans2 res=
ponses for one request =A0*/
> =A0 =A0 =A0 =A0bool multiEnd:1; =A0 =A0 =A0 =A0/* both received */
> };
>
> Using different structs here means that you need an entirely differen=
t
> set of code to deal with them. IMO, the memory savings (if any) isn't
> worth the duplicate code that'll be necessary.
>

When we need to work only with common field we can always assign it to
a common mid_q_entry pointer and work with it. But when we need to
work with protocol dependent fields we will do check like (in both
variants - yours and mine)

if (protocol =3D=3D SMB2)
    smb2_func
else
    cifs_func

So, we don't need entirely different set of code. We will have common
routines as well as cifs and smb2 specific ones. It seems that you
suggest the same - I understand so. Please, sorry me, if I am
mistaken.

--=20
Best regards,
Pavel Shilovsky.
