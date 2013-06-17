From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v3 12/13] seq_file: add seq_list_*_percpu
	helpers
Date: Mon, 17 Jun 2013 11:13:55 -0400
Message-ID: <1371482036-15958-13-git-send-email-jlayton@redhat.com>
References: <1371482036-15958-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
        cluster-devel@redhat.com, sage@inktank.com,
        samba-technical@lists.samba.org, Trond.Myklebust@netapp.com,
        linux-kernel@vger.kernel.org, piastryyy@gmail.com,
        linux-afs@lists.infradead.org, dhowells@redhat.com, smfrench@gmail.com,
        linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org,
        akpm@linux-foundation.org
To: viro@zeniv.linux.org.uk, matthew@wil.cx, bfields@fieldses.org
Return-path: <cluster-devel-bounces@redhat.com>
In-Reply-To: <1371482036-15958-1-git-send-email-jlayton@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/cluster-devel>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=subscribe>
Sender: cluster-devel-bounces@redhat.com
Errors-To: cluster-devel-bounces@redhat.com
List-Id: linux-cifs.vger.kernel.org

When we convert the file_lock_list to a set of percpu lists, we'll need
a way to iterate over them in order to output /proc/locks info. Add
some seq_list_*_percpu helpers to handle that.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Acked-by: J. Bruce Fields <bfields@fieldses.org>
---
 fs/seq_file.c            |   54 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/seq_file.h |    6 +++++
 2 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index 774c1eb..3135c25 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -921,3 +921,57 @@ struct hlist_node *seq_hlist_next_rcu(void *v,
 		return rcu_dereference(node->next);
 }
 EXPORT_SYMBOL(seq_hlist_next_rcu);
+
+/**
+ * seq_hlist_start_precpu - start an iteration of a percpu hlist array
+ * @head: pointer to percpu array of struct hlist_heads
+ * @cpu:  pointer to cpu "cursor"
+ * @pos:  start position of sequence
+ *
+ * Called at seq_file->op->start().
+ */
+struct hlist_node *
+seq_hlist_start_percpu(struct hlist_head __percpu *head, int *cpu, loff_t pos)
+{
+	struct hlist_node *node;
+
+	for_each_possible_cpu(*cpu) {
+		hlist_for_each(node, per_cpu_ptr(head, *cpu)) {
+			if (pos-- == 0)
+				return node;
+		}
+	}
+	return NULL;
+}
+EXPORT_SYMBOL(seq_hlist_start_percpu);
+
+/**
+ * seq_hlist_next_percpu - move to the next position of the percpu hlist array
+ * @v:    pointer to current hlist_node
+ * @head: pointer to percpu array of struct hlist_heads
+ * @cpu:  pointer to cpu "cursor"
+ * @pos:  start position of sequence
+ *
+ * Called at seq_file->op->next().
+ */
+struct hlist_node *
+seq_hlist_next_percpu(void *v, struct hlist_head __percpu *head,
+			int *cpu, loff_t *pos)
+{
+	struct hlist_node *node = v;
+
+	++*pos;
+
+	if (node->next)
+		return node->next;
+
+	for (*cpu = cpumask_next(*cpu, cpu_possible_mask); *cpu < nr_cpu_ids;
+	     *cpu = cpumask_next(*cpu, cpu_possible_mask)) {
+		struct hlist_head *bucket = per_cpu_ptr(head, *cpu);
+
+		if (!hlist_empty(bucket))
+			return bucket->first;
+	}
+	return NULL;
+}
+EXPORT_SYMBOL(seq_hlist_next_percpu);
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index 2da29ac..4e32edc 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -173,4 +173,10 @@ extern struct hlist_node *seq_hlist_start_head_rcu(struct hlist_head *head,
 extern struct hlist_node *seq_hlist_next_rcu(void *v,
 						   struct hlist_head *head,
 						   loff_t *ppos);
+
+/* Helpers for iterating over per-cpu hlist_head-s in seq_files */
+extern struct hlist_node *seq_hlist_start_percpu(struct hlist_head __percpu *head, int *cpu, loff_t pos);
+
+extern struct hlist_node *seq_hlist_next_percpu(void *v, struct hlist_head __percpu *head, int *cpu, loff_t *pos);
+
 #endif
-- 
1.7.1
