From: NeilBrown <neilb-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH] cifs: don't check for failure from mempool_alloc()
Date: Mon, 10 Apr 2017 12:08:53 +1000
Message-ID: <87h91xxbd6.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


mempool_alloc() cannot fail if the gfp flags allow it to
sleep, and both GFP_FS allows for sleeping.

So these tests of the return value from mempool_alloc()
cannot be needed.

Signed-off-by: NeilBrown <neilb-IBi9RG/b67k@public.gmane.org>
=2D--
 fs/cifs/misc.c          | 14 +++++---------
 fs/cifs/smb2transport.c | 30 +++++++++++++-----------------
 fs/cifs/transport.c     | 32 ++++++++++++++------------------
 3 files changed, 32 insertions(+), 44 deletions(-)

diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index d3fb11529ed9..843787850435 100644
=2D-- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -167,13 +167,11 @@ cifs_buf_get(void)
=20
 	/* clear the first few header bytes */
 	/* for most paths, more is cleared in header_assemble */
=2D	if (ret_buf) {
=2D		memset(ret_buf, 0, buf_size + 3);
=2D		atomic_inc(&bufAllocCount);
+	memset(ret_buf, 0, buf_size + 3);
+	atomic_inc(&bufAllocCount);
 #ifdef CONFIG_CIFS_STATS2
=2D		atomic_inc(&totBufAllocCount);
+	atomic_inc(&totBufAllocCount);
 #endif /* CONFIG_CIFS_STATS2 */
=2D	}
=20
 	return ret_buf;
 }
@@ -201,15 +199,13 @@ cifs_small_buf_get(void)
    albeit slightly larger than necessary and maxbuffersize
    defaults to this and can not be bigger */
 	ret_buf =3D mempool_alloc(cifs_sm_req_poolp, GFP_NOFS);
=2D	if (ret_buf) {
 	/* No need to clear memory here, cleared in header assemble */
 	/*	memset(ret_buf, 0, sizeof(struct smb_hdr) + 27);*/
=2D		atomic_inc(&smBufAllocCount);
+	atomic_inc(&smBufAllocCount);
 #ifdef CONFIG_CIFS_STATS2
=2D		atomic_inc(&totSmBufAllocCount);
+	atomic_inc(&totSmBufAllocCount);
 #endif /* CONFIG_CIFS_STATS2 */
=20
=2D	}
 	return ret_buf;
 }
=20
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 506b67fc93d9..c69ec96e92ac 100644
=2D-- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -538,23 +538,19 @@ smb2_mid_entry_alloc(const struct smb2_sync_hdr *shdr,
 	}
=20
 	temp =3D mempool_alloc(cifs_mid_poolp, GFP_NOFS);
=2D	if (temp =3D=3D NULL)
=2D		return temp;
=2D	else {
=2D		memset(temp, 0, sizeof(struct mid_q_entry));
=2D		temp->mid =3D le64_to_cpu(shdr->MessageId);
=2D		temp->pid =3D current->pid;
=2D		temp->command =3D shdr->Command; /* Always LE */
=2D		temp->when_alloc =3D jiffies;
=2D		temp->server =3D server;
=2D
=2D		/*
=2D		 * The default is for the mid to be synchronous, so the
=2D		 * default callback just wakes up the current task.
=2D		 */
=2D		temp->callback =3D cifs_wake_up_task;
=2D		temp->callback_data =3D current;
=2D	}
+	memset(temp, 0, sizeof(struct mid_q_entry));
+	temp->mid =3D le64_to_cpu(shdr->MessageId);
+	temp->pid =3D current->pid;
+	temp->command =3D shdr->Command; /* Always LE */
+	temp->when_alloc =3D jiffies;
+	temp->server =3D server;
+
+	/*
+	 * The default is for the mid to be synchronous, so the
+	 * default callback just wakes up the current task.
+	 */
+	temp->callback =3D cifs_wake_up_task;
+	temp->callback_data =3D current;
=20
 	atomic_inc(&midCount);
 	temp->mid_state =3D MID_REQUEST_ALLOCATED;
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index f6e13a977fc8..4d64b5b8fc9c 100644
=2D-- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -55,26 +55,22 @@ AllocMidQEntry(const struct smb_hdr *smb_buffer, struct=
 TCP_Server_Info *server)
 	}
=20
 	temp =3D mempool_alloc(cifs_mid_poolp, GFP_NOFS);
=2D	if (temp =3D=3D NULL)
=2D		return temp;
=2D	else {
=2D		memset(temp, 0, sizeof(struct mid_q_entry));
=2D		temp->mid =3D get_mid(smb_buffer);
=2D		temp->pid =3D current->pid;
=2D		temp->command =3D cpu_to_le16(smb_buffer->Command);
=2D		cifs_dbg(FYI, "For smb_command %d\n", smb_buffer->Command);
+	memset(temp, 0, sizeof(struct mid_q_entry));
+	temp->mid =3D get_mid(smb_buffer);
+	temp->pid =3D current->pid;
+	temp->command =3D cpu_to_le16(smb_buffer->Command);
+	cifs_dbg(FYI, "For smb_command %d\n", smb_buffer->Command);
 	/*	do_gettimeofday(&temp->when_sent);*/ /* easier to use jiffies */
=2D		/* when mid allocated can be before when sent */
=2D		temp->when_alloc =3D jiffies;
=2D		temp->server =3D server;
+	/* when mid allocated can be before when sent */
+	temp->when_alloc =3D jiffies;
+	temp->server =3D server;
=20
=2D		/*
=2D		 * The default is for the mid to be synchronous, so the
=2D		 * default callback just wakes up the current task.
=2D		 */
=2D		temp->callback =3D cifs_wake_up_task;
=2D		temp->callback_data =3D current;
=2D	}
+	/*
+	 * The default is for the mid to be synchronous, so the
+	 * default callback just wakes up the current task.
+	 */
+	temp->callback =3D cifs_wake_up_task;
+	temp->callback_data =3D current;
=20
 	atomic_inc(&midCount);
 	temp->mid_state =3D MID_REQUEST_ALLOCATED;
=2D-=20
2.12.2


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljq6TUACgkQOeye3VZi
gbkKjhAAsKAWAddsPh7QL8t5VSEch9D9HFt6SU5ycrZ1nBr6OtKwBIK+UkEyVS3h
LaDX8YQSvMi93efi3OiJnsYxlaNcNaJd4vY4qXT5kIaHH5bVC0Hu0QKLVt/q1qT4
7VgrLGRjuHdE9owsOvM8I+zjwF8rSmHw7zjxdRuzmUAoPGdXTrz6GtPmFFbVAwtW
4u/EK8TzQpxEJsjrQHppo5CtqZvOIa4lYippex4DxmvKy+liGVEoZFbHZn8qJ1qV
9kjFS5djO1OxMruAnXRCSY0+8CwFe0LQ4Qkm2jYrCHBc1dIQm8ivLsIEnH4yFFt2
+gUVM3Ls66Pt+G1e6EGtFC4BRKwYc47OSl0ZVjcLoU365xf1Cgt3j79FbTQscJDi
nCmD4x81TC56+PUMBC5xlxmroq5lw/wvpfDSeUx0exkPk9TaGFRsWOHcg3o7Pz/H
ExqYbB9syozRfWPRHdHynltfzuk8KzT6zc1EXsfNv1WQi3uiJtakX/LnQrNOBg0o
2Cc3a+c5wLadDErHZE0TSFalTjYE6w1knKm5Lli5fxMV3wCQNuWX22pS+C3JfbQw
z5Envq4Qnr8RelKAwr8JUN8lvbwzVwYXFVWiCpOi11CsINsRFEFsFbrz79BhScm2
A5Wicnefa0qPQeHftP+gFgGORduJQkl7u5Wmn248zUq2+gLIwR8=
=p1e0
-----END PGP SIGNATURE-----
--=-=-=--
