export default async function clear(args, context) {
  // Signal to controller to clear output
  return { _clearScreen: true }
}
