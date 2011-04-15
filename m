From: Jeff Layton <jlayton@redhat.com>
Subject: Re: mids and cifs sendrcv2
Date: Fri, 15 Apr 2011 11:21:23 -0400
Message-ID: <20110415112123.0a3c2996@corrin.poochiereds.net>
References: <BANLkTi=tUrieqB4jCo0GRX3Np10JxJUP9Q@mail.gmail.com>
	<BANLkTikLfy=4BPESJEmOe+mBhKSRtC=W6A@mail.gmail.com>
	<BANLkTiknBBtzjEjXK5N=SpUaU=b4GAos_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastryyy@gmail.com>, linux-cifs@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Steve French <smfrench@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <BANLkTiknBBtzjEjXK5N=SpUaU=b4GAos_A@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Fri, 15 Apr 2011 08:38:59 -0500
Steve French <smfrench@gmail.com> wrote:

> On Fri, Apr 15, 2011 at 5:45 AM, Pavel Shilovsky <piastryyy@gmail.com=
> wrote:
> > 2011/4/8 Steve French <smfrench@gmail.com>:
> >> Update on cifs vs. smb2 mids, and the smb2 sendrcv2. =C2=A0 Jeff h=
ad
> >> suggested more closely matching the cifs and smb2 mids, in particu=
lar
> >> extending the 16 bit cifs mid (multiplex identifier for inflight
> >> network requests) to the 64 bit size needed for smb2 (and thus mas=
king
> >> the mid when used for cifs) and having cifs ignore the various smb=
2
> >> unique fields in the mid (which makes the mid larger for cifs).
> >> Since the smb2 code in cifs-2.6.git (put in February and early Mar=
ch)
> >> has now been rereviewed, the next step in the smb2 merge is postin=
g
> >> and reviewing the transport routine for smb2 (smb2_sendrcv2 or reu=
sing
> >> cifs_sendrcv2) - the latter may make more sense if we go to a comm=
on
> >> mid for cifs and smb2. =C2=A0 At the fs summit, Jeff and Jeremy an=
d I
> >> talked about this, but Pavel and others may have opinions on this
> >> topic. =C2=A0 As soon as the cifs merge activity settles down for =
2.6.39, I
> >> plan to post sendrcv2 alternatives and then begin work with Pavel =
on
> >> the superblock, file and inode routines and seeing whether for smb=
2
> >> they should be smb2 unique (as we originally expected since smb2 i=
s
> >> handle based, and simpler) and look more like they did in the smb2=
=2Eko
> >> work that Pavel did last summer or should be more common with the =
cifs
> >> routines.
> >>
> >> --
> >> Thanks,
> >>
> >> Steve
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-ci=
fs" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info=
=2Ehtml
> >>
> >
> > I suggest to make cifs and smb2 protocol mid structures use common
> > structure that has equals fields for both and then expand this
> > structure for protocol-dependent things.
> >
> > It can look like this:
> >
> > /* one of these for every pending CIFS request to the server */
> > struct mid_q_entry {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0__u8 protocol_id;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0struct list_head qhead; /* mids waiting =
on reply from this server */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0int midState; =C2=A0 /* wish this were e=
num but can not pass to wait_event */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long when_alloc; =C2=A0/* when =
mid was created */
> > #ifdef CONFIG_CIFS_STATS2
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long when_sent; /* time when sm=
b send finished */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long when_received; /* when dem=
ux complete (taken off wire) */
> > #endif
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0bool largeBuf:1; =C2=A0 =C2=A0 =C2=A0 =C2=
=A0/* if valid response, is pointer to large buf */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0void *resp_buf; =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 /* response buffer */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0mid_callback_t *callback; /* call comple=
tion callback */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0void *callback_data; =C2=A0 =C2=A0 =C2=A0=
/* general purpose pointer for callback */
> > };
> >
> > struct cifs_mid_q_entry {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0struct mid_q_entry mid_q;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0__u16 mid; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0/* multiplex id */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0__u32 sequence_number; =C2=A0/* for CIFS=
 signing */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0__u8 command; =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 /* smb command code */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0__u16 pid; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0/* process id */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0bool multiRsp:1; =C2=A0 =C2=A0 =C2=A0 =C2=
=A0/* multiple trans2 responses for one request =C2=A0*/
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0bool multiEnd:1; =C2=A0 =C2=A0 =C2=A0 =C2=
=A0/* both received */
> > };
> >
> > struct smb2_mid_q_entry {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0struct mid_q_entry mid_q;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0__u64 mid; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0/* multiplex id(s), bigger for smb2 */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0__le16 command; =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 /* smb2 command code */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0__u32 pid; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0/* process id - bigger for smb2 than cifs */
> > };
>=20
> I think nested mid structures (around a base of common mid fields)
> like the above is going to be the easiest way to handle the differenc=
es.
>=20
> I don't understand your PROTOCOL_ID #define though - we
> identify smb2 vs. cifs via a bool in the tcp server info struct,
> and presumably if we don't have access to the tcp server
> info struct we would have to add a field in the base mid
> (struct mid_q_entry) that indicates smb2 vs. cifs..
>=20

Why do even that? Why not a common mid struct that's simply a little la=
rger? Sure it means slightly more memory consumption, but we never have=
 that many in flight. Something like:

struct mid_q_entry {
        __u8 protocol_id;
        struct list_head qhead; /* mids waiting on reply from this serv=
er */
        int midState;   /* wish this were enum but can not pass to wait=
_event */
        unsigned long when_alloc;  /* when mid was created */
#ifdef CONFIG_CIFS_STATS2
        unsigned long when_sent; /* time when smb send finished */
        unsigned long when_received; /* when demux complete (taken off =
wire) */
#endif
        bool largeBuf:1;        /* if valid response, is pointer to lar=
ge buf */
        void *resp_buf;         /* response buffer */
        mid_callback_t *callback; /* call completion callback */
        void *callback_data;      /* general purpose pointer for callba=
ck */
 	__u64 mid;              /* multiplex id */
        __le16 command;         /* command code */
        __u32 pid;              /* process id */
	__u32 sequence_number;  /* for CIFS signing */
        bool multiRsp:1;        /* multiple trans2 responses for one re=
quest  */
        bool multiEnd:1;        /* both received */
};

Using different structs here means that you need an entirely different
set of code to deal with them. IMO, the memory savings (if any) isn't
worth the duplicate code that'll be necessary.

--=20
Jeff Layton <jlayton@redhat.com>
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
