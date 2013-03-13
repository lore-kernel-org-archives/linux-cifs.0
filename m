From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] cifs: Rename cERROR and cifserror to cifs_vfs_err
Date: Wed, 13 Mar 2013 05:40:21 -0700
Message-ID: <1363178421.2031.29.camel@joe-AO722>
References: <1363128287.23052.21.camel@joe-AO722>
	 <1363174614.2031.9.camel@joe-AO722>
	 <20130313075155.7464a34a@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130313075155.7464a34a-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 2013-03-13 at 07:51 -0400, Jeff Layton wrote:
> On Wed, 13 Mar 2013 04:36:54 -0700
> Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org> wrote:
> > Perhaps a better idea than this patch is to
> > change both the cERROR and cFYI macros to
> > a new use of cifs_dbg(type, fmt, ...)
> > 
> > cERROR(set, fmt, ...)   -> cifs_dbg(VFS, fmt, ...)
> > cFYI(set, fmt, ...)     -> cifs_dbg(FYI, fmt, ...)
> > 
> > This conversion would mark both these macros
> > as debug stataments as they are only enabled
> > with CONFIG_CIFS_DEBUG.
[]
> > This would also enable an easier conversion to
> > dynamic debugging of these debug macros.
> > 
> > I'd prefer to move the newline from the macro
> > to the format as that is more consistent with
> > the rest of the kernel.
[]
> I like this change overall, but the size of the patch is pretty
> daunting.

I'd characterize it as more mechanically dull than
daunting, but it is awfully large (~300 KB).

> If you could change the code that underlies cERROR() and
> cFYI() without needing to touch all of their call sites, it might be
> a simpler initial step.

I think that would not help.

> OTOH, I would also prefer to move the newline into the format and
> that's impossible without touching most of these call sites.

Well, all but the ones that already have a defective
newline.  I think there are 4 or 5.

The .ko size increases a few hundred bytes when the
newlines are moved to the format, though it's still
about a 1% overall size reduction.

There would be:

264 uses of cifs_dbg(VFS, ...)
622 uses of cifs_dbg(FYI, ...)
 15 uses of cifs_dbg(NOISY, ...)

to verify. Using strings on the .ko simplifies that.

$ size fs/cifs/cifs.ko*
   text	   data	    bss	    dec	    hex	filename
 265891	   2525	    132	 268548	  41904	fs/cifs/cifs.ko.new
 268359	   2525	    132	 271016	  422a8	fs/cifs/cifs.ko.old

The core of it is to cifs_debug.h
---
 fs/cifs/cifs_debug.h | 70 +++++++++++++++++-----------------------------------
 1 file changed, 23 insertions(+), 47 deletions(-)

diff --git a/fs/cifs/cifs_debug.h b/fs/cifs/cifs_debug.h
index 69ae3d3..c99b40f 100644
--- a/fs/cifs/cifs_debug.h
+++ b/fs/cifs/cifs_debug.h
@@ -25,18 +25,20 @@
 void cifs_dump_mem(char *label, void *data, int length);
 void cifs_dump_detail(void *);
 void cifs_dump_mids(struct TCP_Server_Info *);
-#ifdef CONFIG_CIFS_DEBUG2
-#define DBG2 2
-#else
-#define DBG2 0
-#endif
 extern int traceSMB;		/* flag which enables the function below */
 void dump_smb(void *, int);
 #define CIFS_INFO	0x01
 #define CIFS_RC		0x02
 #define CIFS_TIMER	0x04
 
+#define VFS 1
+#define FYI 2
 extern int cifsFYI;
+#ifdef CONFIG_CIFS_DEBUG2
+#define NOISY 4
+#else
+#define NOISY 0
+#endif
 
 /*
  *	debug ON
@@ -44,31 +46,21 @@ extern int cifsFYI;
  */
 #ifdef CONFIG_CIFS_DEBUG
 
-/* information message: e.g., configuration, major event */
-#define cifsfyi(fmt, ...)						\
-do {									\
-	if (cifsFYI & CIFS_INFO)					\
-		printk(KERN_DEBUG "%s: " fmt "\n",			\
-		       __FILE__, ##__VA_ARGS__);			\
-} while (0)
-
-#define cFYI(set, fmt, ...)						\
-do {									\
-	if (set)							\
-		cifsfyi(fmt, ##__VA_ARGS__);				\
-} while (0)
+__printf(1, 2) void cifs_vfs_err(const char *fmt, ...);
 
-#define cifswarn(fmt, ...)						\
-	printk(KERN_WARNING fmt "\n", ##__VA_ARGS__)
-
-/* error event message: e.g., i/o error */
-#define cifserror(fmt, ...)						\
-	printk(KERN_ERR "CIFS VFS: " fmt "\n", ##__VA_ARGS__);		\
-
-#define cERROR(set, fmt, ...)						\
+/* information message: e.g., configuration, major event */
+#define cifs_dbg(type, fmt, ...)					\
 do {									\
-	if (set)							\
-		cifserror(fmt, ##__VA_ARGS__);				\
+	if (type == FYI) {						\
+		if (cifsFYI & CIFS_INFO) {				\
+			printk(KERN_DEBUG "%s: " fmt,			\
+			       __FILE__, ##__VA_ARGS__);		\
+		}							\
+	} else if (type == VFS) {					\
+		cifs_vfs_err(fmt, ##__VA_ARGS__);			\
+	} else if (type == NOISY && type != 0) {			\
+		printk(KERN_DEBUG fmt, ##__VA_ARGS__);			\
+	}								\
 } while (0)
 
 /*
@@ -76,27 +68,11 @@ do {									\
  *	---------
  */
 #else		/* _CIFS_DEBUG */
-#define cifsfyi(fmt, ...)						\
+#define cifs_dbg(type, fmt, ...)					\
 do {									\
 	if (0)								\
-		printk(KERN_DEBUG "%s: " fmt "\n",			\
-		       __FILE__, ##__VA_ARGS__);			\
+		printk(KERN_DEBUG fmt, ##__VA_ARGS__);			\
 } while (0)
-#define cFYI(set, fmt, ...)						\
-do {									\
-	if (0 && set)							\
-		cifsfyi(fmt, ##__VA_ARGS__);				\
-} while (0)
-#define cifserror(fmt, ...)						\
-do {									\
-	if (0)								\
-		printk(KERN_ERR "CIFS VFS: " fmt "\n", ##__VA_ARGS__);	\
-} while (0)
-#define cERROR(set, fmt, ...)						\
-do {									\
-	if (0 && set)							\
-		cifserror(fmt, ##__VA_ARGS__);				\
-} while (0)
-#endif		/* _CIFS_DEBUG */
+#endif
 
 #endif				/* _H_CIFS_DEBUG */
