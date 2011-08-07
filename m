From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: new sparse warning fs/cifs/cifsfs.c:168:15: warning: dereference
 of noderef expression fs/cifs/cifsfs.c:542:15: warning: dereference of
 noderef expression
Date: Sun, 7 Aug 2011 18:48:29 +0100
Message-ID: <20110807174829.GY2203@ZenIV.linux.org.uk>
References: <CAH2r5mszsiu2Gm-DPbfT8UReT=eBTf4Du4eyEapG8Ayn7UN1pw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5mszsiu2Gm-DPbfT8UReT=eBTf4Du4eyEapG8Ayn7UN1pw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Aug 07, 2011 at 11:22:51AM -0500, Steve French wrote:
> I noticed a series of sparse warnings (on all calls to cifs's GetXid
> after building on a newly install fc15 system (yum installed a sparse
> binary dated June 23).
> 
> fs/cifs/cifsfs.c:168:15: warning: dereference of noderef expression
> fs/cifs/cifsfs.c:542:15: warning: dereference of noderef expression
> 
> Has sparse changed to add a new warning - I see (from quick search)
> others getting this on other modules years ago, but I didn't see
> anything obvious wrong with the definition of the function, and I
> hadn't noticed sparse complaining about it before, and would like to
> remove the 50+ new messages as they clutter the build output.

It's not sparse change - the whinge comes from current_fsuid(), i.e. direct
read of current->cred, even though it's declared with __rcu.  The thing is,
current->cred does *not* need rcu_dereference() - only the task itself
can change it.  Easily fixed...

Signed-off-by: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
---
diff --git a/include/linux/cred.h b/include/linux/cred.h
index 48e82af..98f46ef 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -265,10 +265,11 @@ static inline void put_cred(const struct cred *_cred)
 /**
  * current_cred - Access the current task's subjective credentials
  *
- * Access the subjective credentials of the current task.
+ * Access the subjective credentials of the current task.  RCU-safe,
+ * since nobody else can modify it.
  */
 #define current_cred() \
-	(current->cred)
+	(*(__force struct cred **)&current->cred)
 
 /**
  * __task_cred - Access a task's objective credentials
@@ -307,7 +308,7 @@ static inline void put_cred(const struct cred *_cred)
 ({							\
 	struct user_struct *__u;			\
 	struct cred *__cred;				\
-	__cred = (struct cred *) current_cred();	\
+	__cred = current_cred();			\
 	__u = get_uid(__cred->user);			\
 	__u;						\
 })
@@ -322,7 +323,7 @@ static inline void put_cred(const struct cred *_cred)
 ({							\
 	struct group_info *__groups;			\
 	struct cred *__cred;				\
-	__cred = (struct cred *) current_cred();	\
+	__cred = current_cred();			\
 	__groups = get_group_info(__cred->group_info);	\
 	__groups;					\
 })
@@ -341,7 +342,7 @@ static inline void put_cred(const struct cred *_cred)
 
 #define current_cred_xxx(xxx)			\
 ({						\
-	current->cred->xxx;			\
+	current_cred()->xxx;			\
 })
 
 #define current_uid()		(current_cred_xxx(uid))
