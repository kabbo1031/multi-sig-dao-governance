function validateOwners(owners, threshold) {
  if (threshold > owners.length) return false;
  if (new Set(owners).size !== owners.length) return false;
  return true;
}
module.exports = { validateOwners };
