From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v1 11/11] locks: give the blocked_hash its own spinlock
Date: Tue, 4 Jun 2013 07:46:40 -0700
Message-ID: <20130604144640.GA7730@infradead.org>
References: <1370056054-25449-1-git-send-email-jlayton@redhat.com>
 <1370056054-25449-12-git-send-email-jlayton@redhat.com>
 <51ADF789.70906@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Layton <jlayton@redhat.com>, viro@zeniv.linux.org.uk,
	matthew@wil.cx, bfields@fieldses.org, linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
	sage@inktank.com, samba-technical@lists.samba.org,
	Trond.Myklebust@netapp.com, linux-kernel@vger.kernel.org,
	linux-afs@lists.infradead.org, dhowells@redhat.com,
	smfrench@gmail.com, linux-fsdevel@vger.kernel.org,
	ceph-devel@vger.kernel.org, akpm@linux-foundation.org,
	swhiteho@redhat.com
To: "Stefan (metze) Metzmacher" <metze@samba.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51ADF789.70906@samba.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Having RCU for modification mostly workloads never is a good idea, so
I don't think it makes sense to mention it here.

If you care about the overhead it's worth trying to use per-cpu lists,
though.
