From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: crypto apis in cifs module allocating storage for character array
 during run-time vs. dynamic allocation
Date: Mon, 23 Aug 2010 15:58:06 -0500
Message-ID: <AANLkTikyVs+8-=v0--i7tQDCqFzk=r5DrCvx+UZkjaiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Instead of determining and allocating a char array for use during usage of
crypto_shash_* calls, would like to instead dynamically
allocate (and free) storage for the duration of crypto calculation
(crypto_shash_init,
crypto_shash_update, and crypto_shash_final)
But everytime I try, it results in some sort of oops in the cifs module.
The motivation is to avoid sparse warnings like this

  CHECK   fs/cifs/cifsencrypt.c
fs/cifs/cifsencrypt.c:51:33: error: bad constant expression
fs/cifs/cifsencrypt.c:121:33: error: bad constant expression
fs/cifs/cifsencrypt.c:318:33: error: bad constant expression
fs/cifs/cifsencrypt.c:447:33: error: bad constant expression
fs/cifs/cifsencrypt.c:485:33: error: bad constant expression

that are generated because the size is ctx array is undetermined at
compile time.



+struct sdesc {
+       struct shash_desc shash;
+       char *ctx;
+};


@@ -46,21 +46,25 @@ static int cifs_calculate_signature(const struct
smb_hdr *cifs_pdu,
                        struct TCP_Server_Info *server, char *signature)
 {
        int rc = 0;
-       struct {
-               struct shash_desc shash;
-               char ctx[crypto_shash_descsize(server->ntlmssp.md5)];
-       } sdesc;
+       struct sdesc sdesc;

        if (cifs_pdu == NULL || server == NULL || signature == NULL)
                return -EINVAL;

+       sdesc.ctx = kmalloc(crypto_shash_descsize(server->ntlmssp.md5),
+                                                               GFP_KERNEL);
+       if (!sdesc.ctx) {
+               cERROR(1, "cifs_calculate_signature: could not
initialize crypto hmacmd5\n");
+               return -ENOMEM;
+       }
+
        sdesc.shash.tfm = server->ntlmssp.md5;
        sdesc.shash.flags = 0x0;

        rc = crypto_shash_init(&sdesc.shash);
        if (rc) {
                cERROR(1, "could not initialize master crypto API hmacmd5\n");
-               return rc;
+               goto calc_sig_ret;
        }
