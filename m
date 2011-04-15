From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mids and cifs sendrcv2
Date: Fri, 15 Apr 2011 08:38:59 -0500
Message-ID: <BANLkTiknBBtzjEjXK5N=SpUaU=b4GAos_A@mail.gmail.com>
References: <BANLkTi=tUrieqB4jCo0GRX3Np10JxJUP9Q@mail.gmail.com>
	<BANLkTikLfy=4BPESJEmOe+mBhKSRtC=W6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTikLfy=4BPESJEmOe+mBhKSRtC=W6A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Apr 15, 2011 at 5:45 AM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =
wrote:
> 2011/4/8 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> Update on cifs vs. smb2 mids, and the smb2 sendrcv2. =A0 Jeff had
>> suggested more closely matching the cifs and smb2 mids, in particula=
r
>> extending the 16 bit cifs mid (multiplex identifier for inflight
>> network requests) to the 64 bit size needed for smb2 (and thus maski=
ng
>> the mid when used for cifs) and having cifs ignore the various smb2
>> unique fields in the mid (which makes the mid larger for cifs).
>> Since the smb2 code in cifs-2.6.git (put in February and early March=
)
>> has now been rereviewed, the next step in the smb2 merge is posting
>> and reviewing the transport routine for smb2 (smb2_sendrcv2 or reusi=
ng
>> cifs_sendrcv2) - the latter may make more sense if we go to a common
>> mid for cifs and smb2. =A0 At the fs summit, Jeff and Jeremy and I
>> talked about this, but Pavel and others may have opinions on this
>> topic. =A0 As soon as the cifs merge activity settles down for 2.6.3=
9, I
>> plan to post sendrcv2 alternatives and then begin work with Pavel on
>> the superblock, file and inode routines and seeing whether for smb2
>> they should be smb2 unique (as we originally expected since smb2 is
>> handle based, and simpler) and look more like they did in the smb2.k=
o
>> work that Pavel did last summer or should be more common with the ci=
fs
>> routines.
>>
>> --
>> Thanks,
>>
>> Steve
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
> I suggest to make cifs and smb2 protocol mid structures use common
> structure that has equals fields for both and then expand this
> structure for protocol-dependent things.
>
> It can look like this:
>
> /* one of these for every pending CIFS request to the server */
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
> };
>
> struct cifs_mid_q_entry {
> =A0 =A0 =A0 =A0struct mid_q_entry mid_q;
> =A0 =A0 =A0 =A0__u16 mid; =A0 =A0 =A0 =A0 =A0 =A0 =A0/* multiplex id =
*/
> =A0 =A0 =A0 =A0__u32 sequence_number; =A0/* for CIFS signing */
> =A0 =A0 =A0 =A0__u8 command; =A0 =A0 =A0 =A0 =A0 /* smb command code =
*/
> =A0 =A0 =A0 =A0__u16 pid; =A0 =A0 =A0 =A0 =A0 =A0 =A0/* process id */
> =A0 =A0 =A0 =A0bool multiRsp:1; =A0 =A0 =A0 =A0/* multiple trans2 res=
ponses for one request =A0*/
> =A0 =A0 =A0 =A0bool multiEnd:1; =A0 =A0 =A0 =A0/* both received */
> };
>
> struct smb2_mid_q_entry {
> =A0 =A0 =A0 =A0struct mid_q_entry mid_q;
> =A0 =A0 =A0 =A0__u64 mid; =A0 =A0 =A0 =A0 =A0 =A0 =A0/* multiplex id(=
s), bigger for smb2 */
> =A0 =A0 =A0 =A0__le16 command; =A0 =A0 =A0 =A0 /* smb2 command code *=
/
> =A0 =A0 =A0 =A0__u32 pid; =A0 =A0 =A0 =A0 =A0 =A0 =A0/* process id - =
bigger for smb2 than cifs */
> };

I think nested mid structures (around a base of common mid fields)
like the above is going to be the easiest way to handle the differences=
=2E

I don't understand your PROTOCOL_ID #define though - we
identify smb2 vs. cifs via a bool in the tcp server info struct,
and presumably if we don't have access to the tcp server
info struct we would have to add a field in the base mid
(struct mid_q_entry) that indicates smb2 vs. cifs..


> So, we always work with a pointer to common structure mid_q_entry and
> then expand it according to protocol_id filed when we need it:
>
> #define PROTOCOL_ID(mid) (*((__u8 *)mid))
>
> process_mid(struct mid_q_entry *pmid)
> {
> =A0 =A0 =A0 =A0if (PROTOCOL_ID(pmid) =3D=3D SMB2)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0process_smb2_mid((struct smb2_mid_q_en=
try *)pmid);
> =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0process_cifs_mid((struct cifs_mid_q_en=
try *)pmid);
> }
>
>
> --
> Best regards,
> Pavel Shilovsky.
>



--=20
Thanks,

Steve
