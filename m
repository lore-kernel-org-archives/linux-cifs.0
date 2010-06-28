From: David Howells <dhowells@redhat.com>
Subject: Re: [RFC][PATCH 05/10] cifs: define superblock-level cache index objects and register them
Date: Mon, 28 Jun 2010 14:24:45 +0100
Message-ID: <9513.1277731485@redhat.com>
References: <4C289B39.4060901@suse.de> <22746.1277470713@redhat.com> <4C24A4A0.90408@suse.de> <1277220206-3559-1-git-send-email-sjayaraman@suse.de> <yes> <9720.1277312290@redhat.com> <23204.1277472412@redhat.com>
Cc: dhowells@redhat.com, Steve French <smfrench@gmail.com>,
	linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Suresh Jayaraman <sjayaraman@suse.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4C289B39.4060901@suse.de>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Suresh Jayaraman <sjayaraman@suse.de> wrote:

> Did you mean we need to validate differently for different servers?

You may need to, yes, as different servers may make different attributes
available.

This isn't too bad.  Each server index record in the cache has freeform
auxiliary data, just as does each file data record.  You could, say, stick a
byte at the front that indicates what you've stored in there.

David
