From: Rabin Vincent <rabin.vincent-VrBV9hrLPhE@public.gmane.org>
Subject: Re: [PATCH] cifs: fix crash due to race in hmac(md5) handling
Date: Thu, 21 Jul 2016 09:30:53 +0200
Message-ID: <20160721073053.GA31832@axis.com>
References: <1468913181-28163-1-git-send-email-rabin.vincent@axis.com>
 <1469023049.4942.21.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1469023049.4942.21.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Jul 20, 2016 at 02:57:29PM +0100, Sachin Prabhu wrote:
> Rabin, do you have a reliable reproducer for this case? If yes, can you
> please point me to it.

I have only seen one report of the oops in real testing, so I don't have
a case that would reproduce easily on an unmodified kernel, but while
investigating this I made a debug patch which forces the faulty sequence
to occur and provides a 100% reliable reproducer.

The below patched forces the race condition by making two mount.cifs
processes wait for each other in the appropriate places.

With the force-race patch applied and without this fix, the crash occurs
every time when the following sequence of commands is run.  Tested in a
KVM guest on latest mainline with my "unbreak TCP session reuse" patch
applied.

With the force-race patch applied and with this fix, the mount processes
hang since the race condition can never be satisfied.

 cp /sbin/mount.cifs /sbin/cifs1
 cp /sbin/mount.cifs /sbin/cifs2
 mkdir -p cifs cifs2
 cifs1 //192.168.1.1/test cifs -o credentials=/creds &
 sleep 2
 cifs2 //192.168.1.1/test2 cifs2 -o credentials=/creds

8<-------------------------
diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 8347c90..1ed6dfd 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -35,6 +35,32 @@
 #include <linux/highmem.h>
 #include <crypto/skcipher.h>
 
+static struct completion completions[100];
+
+void hack_set_state(int newstate)
+{
+	printk("%s: caller %pF sets state to %d\n", current->comm, (void *)_RET_IP_, newstate);
+	complete(&completions[newstate]);
+}
+
+void hack_wait_for_state(int state)
+{
+	printk("%s caller %pF wants state %d\n", current->comm, (void *)_RET_IP_, state);
+	wait_for_completion(&completions[state]);
+	printk("%s caller %pF got state %d\n", current->comm, (void *)_RET_IP_, state);
+}
+
+static int hack_init(void)
+{
+       int i;
+
+       for (i = 0; i < ARRAY_SIZE(completions); i++)
+               init_completion(&completions[i]);
+
+       return 0;
+}
+late_initcall(hack_init);
+
 static int
 cifs_crypto_shash_md5_allocate(struct TCP_Server_Info *server)
 {
@@ -54,6 +80,7 @@ cifs_crypto_shash_md5_allocate(struct TCP_Server_Info *server)
 
 	size = sizeof(struct shash_desc) +
 			crypto_shash_descsize(server->secmech.md5);
+
 	server->secmech.sdescmd5 = kmalloc(size, GFP_KERNEL);
 	if (!server->secmech.sdescmd5) {
 		crypto_free_shash(server->secmech.md5);
@@ -661,8 +688,10 @@ static int crypto_hmacmd5_alloc(struct TCP_Server_Info *server)
 	unsigned int size;
 
 	/* check if already allocated */
-	if (server->secmech.sdeschmacmd5)
+	if (server->secmech.sdeschmacmd5) {
+		printk("%s: server %p already allocated\n", __func__, server);
 		return 0;
+	}
 
 	server->secmech.hmacmd5 = crypto_alloc_shash("hmac(md5)", 0, 0);
 	if (IS_ERR(server->secmech.hmacmd5)) {
@@ -674,12 +703,28 @@ static int crypto_hmacmd5_alloc(struct TCP_Server_Info *server)
 
 	size = sizeof(struct shash_desc) +
 			crypto_shash_descsize(server->secmech.hmacmd5);
+
+	if (!strcmp(current->comm, "cifs1")) {
+		hack_wait_for_state(10);
+	}
+	if (!strcmp(current->comm, "cifs2")) {
+		hack_set_state(10);
+		hack_wait_for_state(20);
+	}
+
 	server->secmech.sdeschmacmd5 = kmalloc(size, GFP_KERNEL);
+	printk("%s: %s: server %p alloc sdeschmacmd5=%p\n", __func__, current->comm, server, server->secmech.sdeschmacmd5);
 	if (!server->secmech.sdeschmacmd5) {
 		crypto_free_shash(server->secmech.hmacmd5);
 		server->secmech.hmacmd5 = NULL;
 		return -ENOMEM;
 	}
+
+	if (!strcmp(current->comm, "cifs2")) {
+		hack_set_state(30);
+		hack_wait_for_state(40);
+	}
+
 	server->secmech.sdeschmacmd5->shash.tfm = server->secmech.hmacmd5;
 	server->secmech.sdeschmacmd5->shash.flags = 0x0;
 
@@ -745,6 +790,7 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
 
 	mutex_lock(&ses->server->srv_mutex);
 
+	printk("%s: ses %p ses->server %p\n", __func__, ses, ses->server);
 	rc = crypto_hmacmd5_alloc(ses->server);
 	if (rc) {
 		cifs_dbg(VFS, "could not crypto alloc hmacmd5 rc %d\n", rc);
@@ -780,6 +826,11 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
 		goto unlock;
 	}
 
+	if (!strcmp(current->comm, "cifs1")) {
+		hack_set_state(20);
+		hack_wait_for_state(30);
+	}
+
 	rc = crypto_shash_update(&ses->server->secmech.sdeschmacmd5->shash,
 		ntlmv2->ntlmv2_hash,
 		CIFS_HMAC_MD5_HASH_SIZE);
@@ -788,6 +839,8 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
 		goto unlock;
 	}
 
+	hack_set_state(40);
+
 	rc = crypto_shash_final(&ses->server->secmech.sdeschmacmd5->shash,
 		ses->auth_key.response);
 	if (rc)
