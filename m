From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH 1/2] DNS: Separate out CIFS DNS Resolver code
Date: Wed, 4 Aug 2010 14:01:58 -0500
Message-ID: <AANLkTikhKSWKO5L6GBGSWhCHRbicUs4ZNVxA_Y0Qnj-h@mail.gmail.com>
References: <20100804141633.23934.15025.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org,
	linux-afs@lists.infradead.org, Wang Lei <wang840925@gmail.com>,
	Jeff Layton <jlayton@redhat.com>
To: David Howells <dhowells@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100804141633.23934.15025.stgit@warthog.procyon.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Wed, Aug 4, 2010 at 9:16 AM, David Howells <dhowells@redhat.com> wrote:
> From: Wang Lei <wang840925@gmail.com>
>
> Separate out the DNS resolver key type from the CIFS filesystem into its own
> module so that it can be made available for general use, including the AFS
> filesystem module.

Merged, after addressing trivial checkpatch error:

[sfrench@hera cifs-2.6]$ scripts/checkpatch.pl ~/dh1a.patch
ERROR: "(foo*)" should be "(foo *)"
#523: FILE: fs/cifs/dns_resolve.c:75:
+	rc = cifs_convert_address((struct sockaddr*)&ss, hostname, len);

total: 1 errors, 0 warnings, 999 lines checked


-- 
Thanks,

Steve
