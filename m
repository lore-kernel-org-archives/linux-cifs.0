From: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: cifs_readv_callback and smb2_readv_callback are very similar and I
 would like to merge them ...
Date: Wed, 3 Oct 2012 17:36:50 -0700
Message-ID: <CACyXjPzbmK309pj6FR_JgqDyKPFQV5zPqaL7uj1XVTaMMz+P6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi folks,

I want to simplify the read path as the first part of the changes I
would like to perform to introduce multi-channel support.

One impediment is that we have two functions, cifs_readv_callback and
smb2_readv_callback that are very similar. The following shows how
similar:

@@ -1,9 +1,11 @@
 static void
-cifs_readv_callback(struct mid_q_entry *mid)
+smb2_readv_callback(struct mid_q_entry *mid)
 {
 	struct cifs_readdata *rdata =3D mid->callback_data;
 	struct cifs_tcon *tcon =3D tlink_tcon(rdata->cfile->tlink);
 	struct TCP_Server_Info *server =3D tcon->ses->server;
+	struct smb2_hdr *buf =3D (struct smb2_hdr *)rdata->iov.iov_base;
+	unsigned int credits_received =3D 1;
 	struct smb_rqst rqst =3D { .rq_iov =3D &rdata->iov,
 				 .rq_nvec =3D 1,
 				 .rq_pages =3D rdata->pages,
@@ -16,13 +18,13 @@

 	switch (mid->mid_state) {
 	case MID_RESPONSE_RECEIVED:
+		credits_received =3D le16_to_cpu(buf->CreditRequest);
 		/* result already set, check signature */
 		if (server->sec_mode &
 		    (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED)) {
-			int rc =3D 0;
+			int rc;

-			rc =3D cifs_verify_signature(&rqst, server,
-						  mid->sequence_number + 1);
+			rc =3D smb2_verify_signature(&rqst, server);
 			if (rc)
 				cERROR(1, "SMB signature verification returned "
 				       "error =3D %d", rc);
@@ -36,10 +38,14 @@
 		rdata->result =3D -EAGAIN;
 		break;
 	default:
-		rdata->result =3D -EIO;
+		if (rdata->result !=3D -ENODATA)
+			rdata->result =3D -EIO;
 	}

+	if (rdata->result)
+		cifs_stats_fail_inc(tcon, SMB2_READ_HE);
+
 	queue_work(cifsiod_wq, &rdata->work);
 	DeleteMidQEntry(mid);
-	add_credits(server, 1, 0);
+	add_credits(server, credits_received, 0);
 }

So, we start off with a seemingly unused variable, struct smb2_hdr
*buf in smb2_readv_callback.

Then we have unsigned int credits_received in one and not the other.
We always assume a credit received of 1 in cifs_readv_callback. We
could unify these by:

1. declaring credits received in cifs_readv_callback and then
2. calling a protocol-specific credit-extraction routine, ie
server->ops->hdr_get_credits(buf) or something like that. The
CIFS/SMB1 hdr_get_credits function could simply return 1 every time.

Then we have different signature verification routines, but that is
caused by the fact that the signature algorithms are different, with
the message sequence number being passed in by client/server rather
than being in the header. However, this again can be handled by having
a protocol-specific signature algorithm (which we will likely need for
SMB3.0 anyway because it uses a different hashing algorithm) and
passing in the extra info regardless of whether it is needed. The
extra info we pass in could be the MID pointer.

We are almost done. There appears to be a little reorganization of the
code occurring there, and some stats collection in SMB2 that is not in
CIFS by the look of things, but we can fix that.

So, does anyone have any objections to me doing this?

--=20
Regards,
Richard Sharpe
(=E4=BD=95=E4=BB=A5=E8=A7=A3=E6=86=82=EF=BC=9F=E5=94=AF=E6=9C=89=E6=9D=9C=
=E5=BA=B7=E3=80=82--=E6=9B=B9=E6=93=8D)
