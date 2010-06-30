From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 3/3] Add a pair of system calls to make extended file stats available [ver #2]
Date: Wed, 30 Jun 2010 03:33:49 -0600
Message-ID: <CE3451EE-F8B2-47EF-AC1C-4EEEBE68B30F@dilger.ca>
References: <20100630011656.18960.4255.stgit@warthog.procyon.org.uk> <20100630011712.18960.3723.stgit@warthog.procyon.org.uk> <1277862536.9326.3.camel@heimdal.trondhjem.org>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: David Howells <dhowells@redhat.com>, viro@ZenIV.linux.org.uk,
	smfrench@gmail.com, jlayton@redhat.com, mcao@us.ibm.com,
	aneesh.kumar@linux.vnet.ibm.com, linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	samba-technical@lists.samba.org, sjayaraman@suse.de,
	linux-ext4@vger.kernel.org
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <1277862536.9326.3.camel@heimdal.trondhjem.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On 2010-06-29, at 19:48, Trond Myklebust wrote:
>> When the system call is executed, the struct_version ID and query_flags bitmask are read from the buffer to work out what the user is requesting.
> 
> Yes, but could we please also add a flag that allows you to specify that
> the kernel _must_ provide up to date attributes.

To my reading, if the query_flags are set in the input buffer, then the attributes MUST be fetched.  If they are unset, then they MAY be fetched, and the corresponding query_flags will be set in the return buffer.  If the query_flags are not set in the return buffer then I assume the output values are undefined.

In discussions about the proposed "statlite()" API (which this is very similar to) it was desirable that there be separate flags for the individual fields (at least AMC_TIME should be split), since it isn't always clear whether it is "free" to get all of these timestamps, if just one is desired.  For Lustre, in particular, the mtime is stored with the file data (where it is updated), and it is more costly to get this if it isn't needed.

Cheers, Andreas





