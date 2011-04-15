From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mids and cifs sendrcv2
Date: Fri, 15 Apr 2011 14:45:59 +0400
Message-ID: <BANLkTikLfy=4BPESJEmOe+mBhKSRtC=W6A@mail.gmail.com>
References: <BANLkTi=tUrieqB4jCo0GRX3Np10JxJUP9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTi=tUrieqB4jCo0GRX3Np10JxJUP9Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/4/8 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Update on cifs vs. smb2 mids, and the smb2 sendrcv2. =A0 Jeff had
> suggested more closely matching the cifs and smb2 mids, in particular
> extending the 16 bit cifs mid (multiplex identifier for inflight
> network requests) to the 64 bit size needed for smb2 (and thus maskin=
g
> the mid when used for cifs) and having cifs ignore the various smb2
> unique fields in the mid (which makes the mid larger for cifs).
> Since the smb2 code in cifs-2.6.git (put in February and early March)
> has now been rereviewed, the next step in the smb2 merge is posting
> and reviewing the transport routine for smb2 (smb2_sendrcv2 or reusin=
g
> cifs_sendrcv2) - the latter may make more sense if we go to a common
> mid for cifs and smb2. =A0 At the fs summit, Jeff and Jeremy and I
> talked about this, but Pavel and others may have opinions on this
> topic. =A0 As soon as the cifs merge activity settles down for 2.6.39=
, I
> plan to post sendrcv2 alternatives and then begin work with Pavel on
> the superblock, file and inode routines and seeing whether for smb2
> they should be smb2 unique (as we originally expected since smb2 is
> handle based, and simpler) and look more like they did in the smb2.ko
> work that Pavel did last summer or should be more common with the cif=
s
> routines.
>
> --
> Thanks,
>
> Steve
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

I suggest to make cifs and smb2 protocol mid structures use common
structure that has equals fields for both and then expand this
structure for protocol-dependent things.

It can look like this:

/* one of these for every pending CIFS request to the server */
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
};

struct cifs_mid_q_entry {
        struct mid_q_entry mid_q;
        __u16 mid;              /* multiplex id */
        __u32 sequence_number;  /* for CIFS signing */
        __u8 command;           /* smb command code */
        __u16 pid;              /* process id */
        bool multiRsp:1;        /* multiple trans2 responses for one re=
quest  */
        bool multiEnd:1;        /* both received */
};

struct smb2_mid_q_entry {
        struct mid_q_entry mid_q;
        __u64 mid;              /* multiplex id(s), bigger for smb2 */
        __le16 command;         /* smb2 command code */
        __u32 pid;              /* process id - bigger for smb2 than ci=
fs */
};


So, we always work with a pointer to common structure mid_q_entry and
then expand it according to protocol_id filed when we need it:

#define PROTOCOL_ID(mid) (*((__u8 *)mid))

process_mid(struct mid_q_entry *pmid)
{
        if (PROTOCOL_ID(pmid) =3D=3D SMB2)
                process_smb2_mid((struct smb2_mid_q_entry *)pmid);
        else
                process_cifs_mid((struct cifs_mid_q_entry *)pmid);
}


--=20
Best regards,
Pavel Shilovsky.
