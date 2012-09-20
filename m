From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: SMB2 dialect negotiation
Date: Thu, 20 Sep 2012 06:08:04 -0700
Message-ID: <20120920060804.78284ccc@corrin.poochiereds.net>
References: <CAH2r5muWefRUAuJKiNL=22bmO8o4=YVDEPa1SqyDYj67r8fyDw@mail.gmail.com>
	<CAKywueR_orjnybHudns59fwRrAXWDgn3bcRhdxgFgDiwmPYLgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueR_orjnybHudns59fwRrAXWDgn3bcRhdxgFgDiwmPYLgQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 20 Sep 2012 14:46:42 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2012/9/20 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> > Respinning the SMB2/SMB3 mount patch.  As Jeff suggested, if we are
> > going to negotiate only one dialect at a time, we will need a change
> > something like the following.  In addition, we should pull the
> > capabilities out of the structure which contains the default "values"
> > for each dialect.  It also adds some missing SMB3 negotiated
> > capabilities (which for the moment we don't turn on, but which we will
> > need soon).
> >
> > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> > index a39e5b7..e94825c 100644
> > --- a/fs/cifs/cifsglob.h
> > +++ b/fs/cifs/cifsglob.h
> > @@ -179,6 +179,7 @@ struct smb_rqst {
> >  enum smb_version {
> >         Smb_1 = 1,
> >         Smb_21,
> > +       Smb_30,
> >  };
> >
> >  struct mid_q_entry;
> > @@ -371,6 +372,8 @@ struct smb_version_operations {
> >
> >  struct smb_version_values {
> >         char            *version_string;
> > +       __u16           protocol_id;
> > +       __u32           req_capabilities;
> >         __u32           large_lock_type;
> >         __u32           exclusive_lock_type;
> >         __u32           shared_lock_type;
> > @@ -1495,7 +1498,13 @@ extern mempool_t *cifs_mid_poolp;
> >  #define SMB1_VERSION_STRING    "1.0"
> >  extern struct smb_version_operations smb1_operations;
> >  extern struct smb_version_values smb1_values;
> > +#define SMB20_VERSION_STRING   "2.0"
> > +/*extern struct smb_version_operations smb20_operations; */ /* not
> > needed yet */
> > +extern struct smb_version_values smb20_values;
> >  #define SMB21_VERSION_STRING   "2.1"
> >  extern struct smb_version_operations smb21_operations;
> >  extern struct smb_version_values smb21_values;
> > +#define SMB30_VERSION_STRING   "3.0"
> > +/*extern struct smb_version_operations smb30_operations; */ /* not
> > needed yet */
> > +extern struct smb_version_values smb30_values;
> >  #endif /* _CIFS_GLOB_H */
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index a792282..2fdbe08 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -272,6 +272,7 @@ static const match_table_t cifs_cacheflavor_tokens = {
> >  static const match_table_t cifs_smb_version_tokens = {
> >         { Smb_1, SMB1_VERSION_STRING },
> >         { Smb_21, SMB21_VERSION_STRING },
> > +       { Smb_30, SMB30_VERSION_STRING },
> >  };
> >
> >  static int ip_connect(struct TCP_Server_Info *server);
> > @@ -1074,6 +1075,10 @@ cifs_parse_smb_version(char *value, struct smb_vol *vol)
> >                 vol->ops = &smb21_operations;
> >                 vol->vals = &smb21_values;
> >                 break;
> > +       case Smb_30:
> > +               vol->ops = &smb21_operations; /* currently identical with 2.1 */
> > +               vol->vals = &smb30_values;
> > +               break;
> >  #endif
> >         default:
> >                 cERROR(1, "Unknown vers= option specified: %s", value);
> > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > index 2183bb3..503c1e8 100644
> > --- a/fs/cifs/smb2ops.c
> > +++ b/fs/cifs/smb2ops.c
> > @@ -643,8 +643,45 @@ struct smb_version_operations smb21_operations = {
> >         .new_lease_key = smb2_new_lease_key,
> >  };
> >
> > +
> > +struct smb_version_values smb20_values = {
> > +       .version_string = SMB20_VERSION_STRING,
> > +       .protocol_id = SMB20_PROT_ID,
> > +       .req_capabilities = SMB2_GLOBAL_CAP_DFS,
> > +       .large_lock_type = 0,
> > +       .exclusive_lock_type = SMB2_LOCKFLAG_EXCLUSIVE_LOCK,
> > +       .shared_lock_type = SMB2_LOCKFLAG_SHARED_LOCK,
> > +       .unlock_lock_type = SMB2_LOCKFLAG_UNLOCK,
> > +       .header_size = sizeof(struct smb2_hdr),
> > +       .max_header_size = MAX_SMB2_HDR_SIZE,
> > +       .read_rsp_size = sizeof(struct smb2_read_rsp) - 1,
> > +       .lock_cmd = SMB2_LOCK,
> > +       .cap_unix = 0,
> > +       .cap_nt_find = SMB2_NT_FIND,
> > +       .cap_large_files = SMB2_LARGE_FILES,
> > +};
> 
> I think we need vers=2.0 mount option to let user choose this structure.
> 

Let's not add data structures that have no code to back them up. That's
just a maintenance headache and waste of memory for no benefit. I
suggest just dropping the smb20_values struct from the patch. Once
there's a coherent plan to add 2.0 support then it can be added back at
the same time as you add the code needed to support it.

> > +
> >  struct smb_version_values smb21_values = {
> >         .version_string = SMB21_VERSION_STRING,
> > +       .protocol_id = SMB21_PROT_ID,
> > +       .req_capabilities = SMB2_GLOBAL_CAP_DFS | SMB2_GLOBAL_CAP_LEASING |
> > SMB2_GLOBAL_CAP_LARGE_MTU,
> 
> A client can specify only SMB2_GLOBAL_CAP_DFS in request - other two
> are set by the server in a response.
> 
> > +       .large_lock_type = 0,
> > +       .exclusive_lock_type = SMB2_LOCKFLAG_EXCLUSIVE_LOCK,
> > +       .shared_lock_type = SMB2_LOCKFLAG_SHARED_LOCK,
> > +       .unlock_lock_type = SMB2_LOCKFLAG_UNLOCK,
> > +       .header_size = sizeof(struct smb2_hdr),
> > +       .max_header_size = MAX_SMB2_HDR_SIZE,
> > +       .read_rsp_size = sizeof(struct smb2_read_rsp) - 1,
> > +       .lock_cmd = SMB2_LOCK,
> > +       .cap_unix = 0,
> > +       .cap_nt_find = SMB2_NT_FIND,
> > +       .cap_large_files = SMB2_LARGE_FILES,
> > +};
> > +
> > +struct smb_version_values smb30_values = {
> > +       .version_string = SMB30_VERSION_STRING,
> > +       .protocol_id = SMB30_PROT_ID,
> > +       .req_capabilities = SMB2_GLOBAL_CAP_DFS | SMB2_GLOBAL_CAP_LEASING |
> > SMB2_GLOBAL_CAP_LARGE_MTU,
> >         .large_lock_type = 0,
> >         .exclusive_lock_type = SMB2_LOCKFLAG_EXCLUSIVE_LOCK,
> >         .shared_lock_type = SMB2_LOCKFLAG_SHARED_LOCK,
> > diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> > index a7db95f..39d26cb 100644
> > --- a/fs/cifs/smb2pdu.c
> > +++ b/fs/cifs/smb2pdu.c
> > @@ -1,7 +1,7 @@
> >  /*
> >   *   fs/cifs/smb2pdu.c
> >   *
> > - *   Copyright (C) International Business Machines  Corp., 2009, 2011
> > + *   Copyright (C) International Business Machines  Corp., 2009, 2012
> >   *                 Etersoft, 2012
> >   *   Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
> >   *              Pavel Shilovsky (pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org) 2012
> > @@ -304,24 +304,6 @@ free_rsp_buf(int resp_buftype, void *rsp)
> >                 cifs_buf_release(rsp);
> >  }
> >
> > -#define SMB2_NUM_PROT 2
> > -
> > -#define SMB2_PROT   0
> > -#define SMB21_PROT  1
> > -#define BAD_PROT 0xFFFF
> > -
> > -#define SMB2_PROT_ID  0x0202
> > -#define SMB21_PROT_ID 0x0210
> > -#define BAD_PROT_ID   0xFFFF
> > -
> > -static struct {
> > -       int index;
> > -       __le16 name;
> > -} smb2protocols[] = {
> > -       {SMB2_PROT,  cpu_to_le16(SMB2_PROT_ID)},
> > -       {SMB21_PROT, cpu_to_le16(SMB21_PROT_ID)},
> > -       {BAD_PROT,   cpu_to_le16(BAD_PROT_ID)}
> > -};
> >
> >  /*
> >   *
> > @@ -348,7 +330,6 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
> >         int resp_buftype;
> >         struct TCP_Server_Info *server;
> >         unsigned int sec_flags;
> > -       u16 i;
> >         u16 temp = 0;
> >         int blob_offset, blob_length;
> >         char *security_blob;
> > @@ -377,11 +358,10 @@ SMB2_negotiate(const unsigned int xid, struct
> > cifs_ses *ses)
> >
> >         req->hdr.SessionId = 0;
> >
> > -       for (i = 0; i < SMB2_NUM_PROT; i++)
> > -               req->Dialects[i] = smb2protocols[i].name;
> > +       req->Dialects[0] = cpu_to_le16(ses->server->vals->protocol_id);
> >
> > -       req->DialectCount = cpu_to_le16(i);
> > -       inc_rfc1001_len(req, i * 2);
> > +       req->DialectCount = cpu_to_le16(1); /* One vers= at a time for now */
> > +       inc_rfc1001_len(req, 2);
> >
> >         /* only one of SMB2 signing flags may be set in SMB2 request */
> >         if ((sec_flags & CIFSSEC_MUST_SIGN) == CIFSSEC_MUST_SIGN)
> > @@ -391,7 +371,7 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
> >
> >         req->SecurityMode = cpu_to_le16(temp);
> >
> > -       req->Capabilities = cpu_to_le32(SMB2_GLOBAL_CAP_DFS);
> > +       req->Capabilities = cpu_to_le32(ses->server->vals->req_capabilities);
> 
> I think we need to separate Negotiate capabilities field and Session
> Setup one. So, setting it to SMB2_GLOBAL_CAP_DFS here looks like my
> bug: it should be 0 for SMB2.0/SMB2.1 and not 0 for SMB3.0.
> 
> The only place where we should set capabilities for SMB2.0/SMB2.1 is
> Session Setup capabilities filed that can be 0 or SMB2_GLOBAL_CAP_DFS
> for SMB2.0/SMB2.1/SMB3.0.
> 
> >
> >         memcpy(req->ClientGUID, cifs_client_guid, SMB2_CLIENT_GUID_SIZE);
> >
> > @@ -416,10 +396,14 @@ SMB2_negotiate(const unsigned int xid, struct
> > cifs_ses *ses)
> >
> >         cFYI(1, "mode 0x%x", rsp->SecurityMode);
> >
> > -       if (rsp->DialectRevision == smb2protocols[SMB21_PROT].name)
> > +       /* BB we may eventually want to match the negotiated vs. requested
> > +          dialect, even though we are only requesting one at a time */
> > +       if (rsp->DialectRevision == cpu_to_le16(SMB20_PROT_ID))
> > +               cFYI(1, "negotiated smb2.0 dialect");
> > +       else if (rsp->DialectRevision == cpu_to_le16(SMB21_PROT_ID))
> >                 cFYI(1, "negotiated smb2.1 dialect");
> > -       else if (rsp->DialectRevision == smb2protocols[SMB2_PROT].name)
> > -               cFYI(1, "negotiated smb2 dialect");
> > +       else if (rsp->DialectRevision == cpu_to_le16(SMB30_PROT_ID))
> > +               cFYI(1, "negotiated smb3.0 dialect");
> >         else {
> >                 cERROR(1, "Illegal dialect returned by server %d",
> >                            le16_to_cpu(rsp->DialectRevision));

For now, this is probably ok but there's a problem we'll have to deal
with eventually...

If we ever want to make autonegotiation work then you'll need a way to
set the server->ops and server->vals after the negprot response has
come back.

What may be best is to rethink what the vers= option actually does.
Instead of having it set vol->ops and vol->vals, have it just affect
how the negprot is performed and only set vol->ops and ->vals after
that has completed.


> > diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
> > index da09922..4cb4ced 100644
> > --- a/fs/cifs/smb2pdu.h
> > +++ b/fs/cifs/smb2pdu.h
> > @@ -163,9 +163,15 @@ struct smb2_negotiate_req {
> >         __le32 Capabilities;
> >         __u8   ClientGUID[SMB2_CLIENT_GUID_SIZE];
> >         __le64 ClientStartTime; /* MBZ */
> > -       __le16 Dialects[2]; /* variable length */
> > +       __le16 Dialects[1]; /* One dialect (vers=) at a time for now */
> >  } __packed;
> >
> > +/* Dialects */
> > +#define SMB20_PROT_ID 0x0202
> > +#define SMB21_PROT_ID 0x0210
> > +#define SMB30_PROT_ID 0x0300
> > +#define BAD_PROT_ID   0xFFFF
> > +
> >  /* SecurityMode flags */
> >  #define        SMB2_NEGOTIATE_SIGNING_ENABLED  0x0001
> >  #define SMB2_NEGOTIATE_SIGNING_REQUIRED        0x0002
> > @@ -173,6 +179,10 @@ struct smb2_negotiate_req {
> >  #define SMB2_GLOBAL_CAP_DFS            0x00000001
> >  #define SMB2_GLOBAL_CAP_LEASING                0x00000002 /* Resp only New to SMB2.1 */
> >  #define SMB2_GLOBAL_CAP_LARGE_MTU      0X00000004 /* Resp only New to SMB2.1 */
> > +#define SMB2_GLOBAL_CAP_MULTI_CHANNEL  0x00000008 /* New to SMB3 */
> > +#define SMB2_GLOBAL_CAP_PERSISTENT_HANDLES 0x00000010 /* New to SMB3 */
> > +#define SMB2_GLOBAL_CAP_DIRECTORY_LEASING  0x00000020 /* New to SMB3 */
> > +#define SMB2_GLOBAL_CAP_ENCRYPTION     0x00000040 /* New to SMB3 */

These comments are unhelpful. How about comments that describe what
these flags mean instead?

> >  /* Internal types */
> >  #define SMB2_NT_FIND                   0x00100000
> >  #define SMB2_LARGE_FILES               0x00200000
> >
> > --
> > Thanks,
> >
> > Steve
> 
> 
> 


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
